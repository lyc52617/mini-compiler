#ifndef PHEMIA_CODEGEN_HPP
#define PHEMIA_CODEGEN_HPP

#include <stack>
#include <string>
#include <typeinfo>
#include <llvm/IR/Module.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/IRPrintingPasses.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/ExecutionEngine/MCJIT.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <regex>

#include "ast.h"
#include "parser.hpp"
#include "utils.hpp"

#define PRINT(s) std::cout << "\n-------\n";s->print(llvm::outs());std::cout << "\n-------\n";

class NBlock;

class VariableRecord {
public:
    llvm::Value *value;
    llvm::Type *dType;
    std::vector<uint32_t> *size;

    VariableRecord(llvm::Value *value, llvm::Type *dType, std::vector<uint32_t> *size) :
            value(value), dType(dType), size(size) {}
};

class LoopInfo {
public:
    NExpression *cond = nullptr;
    NStatement *inc = nullptr;
    llvm::BasicBlock *loop = nullptr;
    llvm::BasicBlock *after = nullptr;

    LoopInfo(NExpression *cond, NStatement *inc, llvm::BasicBlock *loop, llvm::BasicBlock *after) :
            cond(cond), inc(inc), loop(loop), after(after) {}
};

class Codegenblock {
public:
    llvm::BasicBlock *block = nullptr;
    llvm::Value *retVal = nullptr;
    std::map<std::string, VariableRecord *> localVal;
    LoopInfo *info = nullptr;

    explicit Codegenblock(llvm::BasicBlock *block, llvm::Value *retVal = nullptr, LoopInfo *info = nullptr) : block(
            block), retVal(retVal), info(info) {}
};


class CodeGenContext {
    std::vector<Codegenblock *> codeGenContext;
    llvm::Function *main = nullptr;
public:
    llvm::LLVMContext llvmContext;
    llvm::IRBuilder<> builder;
    llvm::Module *module;
    llvm::BasicBlock *curMerge = nullptr;
    llvm::BasicBlock *curCond = nullptr;
    int inLoop = 0;

    CodeGenContext() : builder(llvmContext) { module = new llvm::Module("main", llvmContext); }

    void generateCode(NBlock &root, const std::string &file);

    llvm::GenericValue runCode();

    std::map<std::string, VariableRecord *> &locals() { return codeGenContext.back()->localVal; }

    VariableRecord *get(const std::string &name) const {
        for (auto it = codeGenContext.rbegin(); it != codeGenContext.rend(); it++) {
            if ((*it)->localVal.find(name) != (*it)->localVal.end()) {
                return (*it)->localVal[name];
            }
        }
        return nullptr;
    }

    auto *current() { return codeGenContext.back(); }

    LoopInfo *currentLoop() {
        for (auto it = codeGenContext.rbegin(); it != codeGenContext.rend(); it++) {
            if ((**it).info) {
                return (**it).info;
            }
        }
        return nullptr;
    }

    void push(llvm::BasicBlock *block) {
        codeGenContext.push_back(new Codegenblock(block));
    }

    void push(llvm::BasicBlock *block, LoopInfo *info) {
        codeGenContext.push_back(new Codegenblock(block, nullptr, info));
    }

    void pop() {
        Codegenblock *top = codeGenContext.back();
        codeGenContext.pop_back();
        delete top;
    }

    void setCurrentReturnValue(llvm::Value *value) { codeGenContext.back()->retVal = value; }

    llvm::Value *getCurrentReturnValue() { return codeGenContext.back()->retVal; }

    llvm::Type *typeOf(const std::string &type) {
        std::smatch result;
        if (type == "int") {
            return llvm::Type::getInt32Ty(llvmContext);
        } else if (type == "float") {
            return llvm::Type::getFloatTy(llvmContext);
        } else if (type == "double") {
            return llvm::Type::getDoubleTy(llvmContext);
        } else if (type == "char") {
            return llvm::Type::getInt8Ty(llvmContext);
        } else if (type == "bool") {
            return llvm::Type::getInt1Ty(llvmContext);
        } else if (type == "string") {
            return llvm::PointerType::getInt8PtrTy(llvmContext);
//            return llvm::ArrayType::get(typeOf("char"), 0);
        } else return llvm::Type::getVoidTy(llvmContext);
    }

    llvm::Value *castToBoolean(llvm::Value *value) {
        if (value->getType()->isIntegerTy()) {
            return builder.CreateICmpNE(value, builder.CreateIntCast(
                    builder.getInt1(false), value->getType(), false));
        } else if (value->getType()->isFloatTy() || value->getType()->isDoubleTy()) {
            return builder.CreateFCmpONE(value, llvm::ConstantFP::get(llvmContext, llvm::APFloat(0.0)));
        } else return builder.getInt1(true);
    }
};

void CodeGenContext::generateCode(NBlock &root, const std::string &file) {
    /* Create the top level interpreter function to call as entry */
    std::vector<llvm::Type *> argTypes;
    llvm::FunctionType *fType = llvm::FunctionType::get(llvm::Type::getInt32Ty(llvmContext),
                                                        llvm::makeArrayRef(argTypes), false);
    main = llvm::Function::Create(fType, llvm::GlobalValue::ExternalLinkage, "main", module);
    llvm::BasicBlock *bBlock = llvm::BasicBlock::Create(llvmContext, "entry", main, nullptr);
    builder.SetInsertPoint(bBlock);
    /* Push a new variable/block context */
    push(bBlock);
    root.codeGen(*this); /* emit bytecode for the toplevel block */
    builder.CreateRet(llvm::ConstantInt::get(typeOf("int"), 0, true));
    pop();


    std::error_code errInfo;


    llvm::raw_fd_ostream out(file, errInfo);
    module->print(out, nullptr);
}

llvm::GenericValue CodeGenContext::runCode() {
    llvm::ExecutionEngine *ee = llvm::EngineBuilder(std::unique_ptr<llvm::Module>(module)).create();
    ee->finalizeObject();
    std::vector<llvm::GenericValue> noArgs;
    llvm::GenericValue v = ee->runFunction(main, noArgs);
    return v;
}

int NExpression::getType() {
    return -1;
}

llvm::Value *NInteger::codeGen(CodeGenContext &context) {
    return llvm::ConstantInt::get(context.typeOf("int"), value, true);
}

int NInteger::getType() {
    return TINTEGER;
}

llvm::Value *NFloat::codeGen(CodeGenContext &context) {
    return llvm::ConstantFP::get(context.typeOf("float"), value);
}

int NFloat::getType() {
    return TFLOAT;
}

llvm::Value *NDouble::codeGen(CodeGenContext &context) {
    return llvm::ConstantFP::get(context.typeOf("double"), value);
}

int NDouble::getType() {
    return TDOUBLE ;
}

llvm::Value *NBool::codeGen(CodeGenContext &context) {
    return llvm::ConstantInt::get(context.typeOf("bool"), value, false);
}

int NBool::getType() {
    return TBOOL;
}

llvm::Value *NChar::codeGen(CodeGenContext &context) {
    return llvm::ConstantInt::get(context.typeOf("char"), value, false);
}

int NChar::getType() {
    return TCHAR;
}

llvm::Value *NString::codeGen(CodeGenContext &context) {
    static int i = 0;
    auto charType = context.typeOf("char");

    std::vector<llvm::Constant *> str;
    for (auto ch: value) {
        str.push_back(llvm::ConstantInt::get(charType, (uint8_t) ch));
    }
    str.push_back(llvm::ConstantInt::get(charType, '\0'));

    auto stringType = llvm::ArrayType::get(charType, str.size());

    auto globalDeclaration = (llvm::GlobalVariable *) context.module->getOrInsertGlobal(".str" + std::to_string(i++),
                                                                                        stringType);
    globalDeclaration->setInitializer(llvm::ConstantArray::get(stringType, str));
    globalDeclaration->setConstant(false);
    globalDeclaration->setLinkage(llvm::GlobalValue::LinkageTypes::PrivateLinkage);
    globalDeclaration->setUnnamedAddr(llvm::GlobalValue::UnnamedAddr::Global);

    return context.builder.CreateBitCast(globalDeclaration, charType->getPointerTo());
}

llvm::Value *NVoid::codeGen(CodeGenContext &context) {
    return llvm::UndefValue::get(context.typeOf("void"));
}



llvm::Value *NBinaryOperator::codeGen(CodeGenContext &context) {
    auto L = this->lhs->codeGen(context);
    auto R = this->rhs->codeGen(context);
    bool isFP = false;

    // type upgrade
    if ((!L->getType()->isIntegerTy()) ||
        (!R->getType()->isIntegerTy())) {
        isFP = true;
        if (R->getType()->isIntegerTy()) {
            R = context.builder.CreateSIToFP(R, llvm::Type::getDoubleTy(context.llvmContext), "FTMP");
        }
        if (L->getType()->isIntegerTy()) {
            L = context.builder.CreateSIToFP(L, llvm::Type::getDoubleTy(context.llvmContext), "FTMP");
        }
    }
    if (!isFP) {
        if (L->getType()->getIntegerBitWidth() < R->getType()->getIntegerBitWidth()) {
            L = context.builder.CreateIntCast(L, R->getType(), true);
        } else if (L->getType()->getIntegerBitWidth() > R->getType()->getIntegerBitWidth()) {
            R = context.builder.CreateIntCast(R, L->getType(), true);
        }
    }

    if (!L || !R) {
        return nullptr;
    }

    switch (op) {
        case TPLUS:
            return isFP ? context.builder.CreateFAdd(L, R, "FPLUS") : context.builder.CreateAdd(L, R, "PLUS");
        case TMINUS:
            return isFP ? context.builder.CreateFSub(L, R, "FMINUS") : context.builder.CreateSub(L, R, "MINUS");
        case TMUL:
            return isFP ? context.builder.CreateFMul(L, R, "FMUL") : context.builder.CreateMul(L, R, "MUL");
        case TDIV:
            return isFP ? context.builder.CreateFDiv(L, R, "FDIV") : context.builder.CreateSDiv(L, R, "DIV");
        case TMOD:
            return isFP ? context.builder.CreateFRem(L, R, "FMOD") : context.builder.CreateSRem(L, R, "MOD");
        case TAND:
            if (isFP) std::cerr << "Compute AND on FP!\n";
            return isFP ? nullptr : context.builder.CreateAnd(L, R, "AND");
        case TOR:
            if (isFP) std::cerr << "Compute OR on FP!\n";
            return isFP ? nullptr : context.builder.CreateOr(L, R, "OR");
        case TXOR:
            if (isFP) std::cerr << "Compute XOR on FP!\n";
            return isFP ? nullptr : context.builder.CreateXor(L, R, "XOR");
        case TCLT:
            return isFP ? context.builder.CreateFCmpULT(L, R, "FLT") : context.builder.CreateICmpSLT(L, R, "LT");
        case TCLE:
            return isFP ? context.builder.CreateFCmpULE(L, R, "FLE") : context.builder.CreateICmpSLE(L, R, "LE");
        case TCGT:
            return isFP ? context.builder.CreateFCmpUGT(L, R, "FGT") : context.builder.CreateICmpSGT(L, R, "GT");
        case TCGE:
            return isFP ? context.builder.CreateFCmpUGE(L, R, "FGE") : context.builder.CreateICmpSGE(L, R, "GE");
        case TCEQ:
            return isFP ? context.builder.CreateFCmpUEQ(L, R, "FEQ") : context.builder.CreateICmpEQ(L, R, "EQ");
        case TCNE:
            return isFP ? context.builder.CreateFCmpUNE(L, R, "FEQ") : context.builder.CreateICmpNE(L, R, "NE");
        default:
            return nullptr;
    }
}

llvm::Value* NIdentifier::codeGen(CodeGenContext& context)
{
    ;
}

llvm::Value* NFunctionCall::codeGen(CodeGenContext& context)
{
    ;
}

llvm::Value* NUnaryOperator::codeGen(CodeGenContext& context)
{
    ;
}
llvm::Value* NAssignment::codeGen(CodeGenContext& context)
{
    ;
}
llvm::Value* NArrayIndex::codeGen(CodeGenContext& context)
{
    ;
}
llvm::Value* NArrayIndexassign::codeGen(CodeGenContext& context)
{
    ;
}
llvm::Value* NExpressionStatement::codeGen(CodeGenContext& context)
{
    ;
}
llvm::Value* NUnaryOperator::codeGen(CodeGenContext& context)
{
    ;
}
llvm::Value* NUnaryOperator::codeGen(CodeGenContext& context)
{
    ;
}
#endif
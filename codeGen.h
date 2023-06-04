#ifndef CODEGEN_H
#define CODEGEN_H

#include <stack>
#include <string>
#include <typeinfo>
#include <iostream>
#include <cctype>
#include <vector>
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
using pairtype= std::pair<std::string,std::string>;
using namespace llvm;

class NBlock;
class VarRecord {
public:
   Value *value;
    Type *dType;
    std::vector<uint32_t> *size;

    VarRecord(Value *value, Type *dType, std::vector<uint32_t> *size) :
            value(value), dType(dType), size(size) {}
};

class LoopRecord {
public:
    NExpression *condition = nullptr;
    NStatement *increment = nullptr;
    BasicBlock *loop = nullptr;
    BasicBlock *after = nullptr;

    LoopRecord(NExpression *condition, NStatement *increment, BasicBlock *loop, BasicBlock *after) :
            condition(condition), increment(increment), loop(loop), after(after) {}
};

class CodeGenBlock {
public:
    BasicBlock *block = nullptr;
    Value *retVal = nullptr;
    std::map<std::string, VarRecord *> localVal;
    LoopRecord *info = nullptr;

    explicit CodeGenBlock(BasicBlock *block, Value *retVal = nullptr, LoopRecord *info = nullptr) : block(
            block), retVal(retVal), info(info) {}
};


class CodeGenContext {
    std::vector<CodeGenBlock *> codegencontext;
    Function *main = nullptr;
public:
    LLVMContext llvmContext;
    IRBuilder<> builder;
    Module *module;
    std::map<std::string,std::vector<pairtype>> structmembers;
    BasicBlock *curMerge = nullptr;
    BasicBlock *curCond = nullptr;
    int inLoop = 0;

    CodeGenContext() : builder(llvmContext) { module = new Module("main", llvmContext); }

    void generateCode(NBlock &root, const std::string &file);

    GenericValue runCode();

    std::map<std::string, VarRecord *> &locals() { return codegencontext.back()->localVal; }

    VarRecord *get(const std::string &name) const {
        for (auto it = codegencontext.rbegin(); it != codegencontext.rend(); it++) {
            if ((*it)->localVal.find(name) != (*it)->localVal.end()) {
                return (*it)->localVal[name];
            }
        }
        return nullptr;
    }
    int getstructmemberindex(std::string structname,std::string membername)
    {
        if(this->structmembers.find(structname)==this->structmembers.end())
        {
            std::cout<<"cannot find the struct"<<std::endl;
            return -1;
        }
        auto& members = this->structmembers[structname];
        for(auto it = members.begin();it !=members.end();it++)
        {
            if(it->second == membername)
            {
                return std::distance(members.begin(),it);
            }
        }
        std::cout<<"unknown struct member"<<std::endl;
        return -1;
    }
    auto *current() { return codegencontext.back(); }

    LoopRecord *currentLoop() {
        for (auto it = codegencontext.rbegin(); it != codegencontext.rend(); it++) {
            if ((**it).info) {
                return (**it).info;
            }
        }
        return nullptr;
    }

    void push(BasicBlock *block) {
        codegencontext.push_back(new CodeGenBlock(block));
    }

    void push(BasicBlock *block, LoopRecord *info) {
        codegencontext.push_back(new CodeGenBlock(block, nullptr, info));
    }

    void pop() {
        CodeGenBlock *top = codegencontext.back();
        codegencontext.pop_back();
        delete top;
    }

    void setCurrentReturnValue(Value *value) { codegencontext.back()->retVal = value; }

    Value *getCurrentReturnValue() { return codegencontext.back()->retVal; }

    Type *typeOf(const std::string &type) {
        std::smatch result;
        if (type == "int") {
            return Type::getInt32Ty(llvmContext);
        } else if (type == "float") {
            return Type::getFloatTy(llvmContext);
        } else if (type == "double") {
            return Type::getDoubleTy(llvmContext);
        } else if (type == "char") {
            return Type::getInt8Ty(llvmContext);
        } else if (type == "boolean") {
            return Type::getInt1Ty(llvmContext);
        } else if (type == "string") {
            return PointerType::getInt8PtrTy(llvmContext);
//            return ArrayType::get(typeOf("char"), 0);
        } else return Type::getVoidTy(llvmContext);
    }

    Value *castToBoolean(Value *value) {
        if (value->getType()->isIntegerTy()) {
            return builder.CreateICmpNE(value, builder.CreateIntCast(
                    builder.getInt1(false), value->getType(), false));
        } else if (value->getType()->isFloatTy() || value->getType()->isDoubleTy()) {
            return builder.CreateFCmpONE(value, ConstantFP::get(llvmContext, APFloat(0.0)));
        } else return builder.getInt1(true);
    }
};
#endif
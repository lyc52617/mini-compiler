#ifndef CODEGEN_HPP
#define CODEGEN_HPP



#include "ast.h"
#include "parser.hpp"
#include "codeGen.h"
using pairtype= std::pair<std::string,std::string>;
using namespace llvm;

#define PRINT(s) std::cout << "\n-------\n";s->print(outs());std::cout << "\n-------\n";

class NBlock;



void CodeGenContext::generateCode(NBlock &root, const std::string &file) {
    /* Create the top level interpreter function to call as entry */
    std::vector<Type *> argTypes;
    FunctionType *fType = FunctionType::get(Type::getInt32Ty(llvmContext),
                                                        makeArrayRef(argTypes), false);
    main = Function::Create(fType, GlobalValue::ExternalLinkage, "main", module);
    BasicBlock *bBlock = BasicBlock::Create(llvmContext, "entry", main, nullptr);
    builder.SetInsertPoint(bBlock);
    /* Push a new variable/block context */
    push(bBlock);
    root.codeGen(*this); /* emit bytecode for the toplevel block */
    builder.CreateRet(ConstantInt::get(typeOf("int"), 0, true));
    pop();

    /* Print the bytecode in a human-readable format to see if our program compiled properly */
//    legacy::PassManager pm;
//    pm.add(createPrintModulePass(outs()));
//    pm.run(*module);
//
    std::error_code errInfo;
//    raw_ostream *out = new raw_fd_ostream(file, errInfo);
//    WriteBitcodeToFile(*module, *out);
//    out->flush();
//    delete out;

    raw_fd_ostream out(file, errInfo);
    module->print(out, nullptr);
}

GenericValue CodeGenContext::runCode() {
    ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();
    ee->finalizeObject();
    std::vector<GenericValue> noArgs;
    GenericValue v = ee->runFunction(main, noArgs);
    return v;
}

int NExpression::getDType() {
    return -1;
}

Value *NInteger::codeGen(CodeGenContext &context) {
    return ConstantInt::get(context.typeOf("int"), value, true);
}

int NInteger::getDType() {
    return TINTEGER;
}

Value *NFloat::codeGen(CodeGenContext &context) {
    return ConstantFP::get(context.typeOf("float"), value);
}

int NFloat::getDType() {
    return TFNUMBER;
}

Value *NDouble::codeGen(CodeGenContext &context) {
    return ConstantFP::get(context.typeOf("double"), value);
}

int NDouble::getDType() {
    return TDNUMBER;
}

Value *NBoolean::codeGen(CodeGenContext &context) {
    return ConstantInt::get(context.typeOf("boolean"), value, false);
}

int NBoolean::getDType() {
    return TBOOL;
}

Value *NChar::codeGen(CodeGenContext &context) {
    return ConstantInt::get(context.typeOf("char"), value, false);
}

int NChar::getDType() {
    return TCHARACTER;
}

Value *NString::codeGen(CodeGenContext &context) {
    static int i = 0;
    auto charType = context.typeOf("char");

    std::vector<Constant *> str;
    for (auto ch: value) {
        str.push_back(ConstantInt::get(charType, (uint8_t) ch));
    }
    str.push_back(ConstantInt::get(charType, '\0'));

    auto stringType = ArrayType::get(charType, str.size());

    auto globalDeclaration = (GlobalVariable *) context.module->getOrInsertGlobal(".str" + std::to_string(i++),
                                                                                        stringType);
    globalDeclaration->setInitializer(ConstantArray::get(stringType, str));
    globalDeclaration->setConstant(false);
    globalDeclaration->setLinkage(GlobalValue::LinkageTypes::PrivateLinkage);
    globalDeclaration->setUnnamedAddr(GlobalValue::UnnamedAddr::Global);

    return context.builder.CreateBitCast(globalDeclaration, charType->getPointerTo());
}

Value *NVoid::codeGen(CodeGenContext &context) {
    return UndefValue::get(context.typeOf("void"));
}

Value *NArray::codeGen(CodeGenContext &context) {
    static int i = 0;
    auto dType = context.typeOf(type->name);
    if (initList) {
        std::vector<Constant *> arr;
        switch ((*initList->begin())->getDType()) {
            case TINTEGER: {
                for (auto ch: *initList) {
                    arr.push_back(ConstantInt::get(dType, dynamic_cast<NInteger *>(ch)->value));
                }
                break;
            }
            case TCHARACTER: {
                for (auto ch: *initList) {
                    arr.push_back(ConstantInt::get(dType, dynamic_cast<NChar *>(ch)->value));
                }
                break;
            }
            case TDNUMBER: {
                for (auto ch: *initList) {
                    arr.push_back(ConstantFP::get(dType, dynamic_cast<NDouble *>(ch)->value));
                }
                break;
            }
            case TFNUMBER: {
                for (auto ch: *initList) {
                    arr.push_back(ConstantInt::get(dType, dynamic_cast<NFloat *>(ch)->value));
                }
                break;
            }
            case TBOOL: {
                for (auto ch: *initList) {
                    arr.push_back(ConstantInt::get(dType, dynamic_cast<NBoolean *>(ch)->value));
                }
                break;
            }
            default:
                break;
        }
        if (arr.empty()) {
            std::cerr << "Unsupported array initialization!\n";
            return nullptr;
        } else {
            auto arrType = ArrayType::get(dType, arr.size());

            auto globalDeclaration = (GlobalVariable *) context.module->getOrInsertGlobal(
                    ".arr" + std::to_string(i++), arrType);
            globalDeclaration->setInitializer(ConstantArray::get(arrType, arr));
            globalDeclaration->setConstant(false);
            globalDeclaration->setLinkage(GlobalValue::LinkageTypes::PrivateLinkage);
            globalDeclaration->setUnnamedAddr(GlobalValue::UnnamedAddr::Global);
            return context.builder.CreateBitCast(globalDeclaration, dType->getPointerTo());
        }
    } else {
        auto *arrSize = new std::vector<uint32_t>();
        arraydim arrayDim;
        uint64_t size = arrayDim.calArrayDim(arrDim, arrSize);
        auto arrType = ArrayType::get(dType, size);
        auto *val = new GlobalVariable(*context.module, arrType, false, GlobalValue::CommonLinkage, 0,
                                             "arr");
        auto *constArr = ConstantAggregateZero::get(arrType);
        val->setInitializer(constArr);
        return context.builder.CreateBitCast(val, dType->getPointerTo());
    }
}

Value *NBinaryOperator::codeGen(CodeGenContext &context) {
    auto L = lhs->codeGen(context);
    auto R = rhs->codeGen(context);
    bool isFP = false;

    // type upgrade
    if ((!L->getType()->isIntegerTy()) ||
        (!R->getType()->isIntegerTy())) {
        isFP = true;
        if (R->getType()->isIntegerTy()) {
            R = context.builder.CreateSIToFP(R, Type::getDoubleTy(context.llvmContext), "FTMP");
        }
        if (L->getType()->isIntegerTy()) {
            L = context.builder.CreateSIToFP(L, Type::getDoubleTy(context.llvmContext), "FTMP");
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
        case TLT:
            return isFP ? context.builder.CreateFCmpULT(L, R, "FLT") : context.builder.CreateICmpSLT(L, R, "LT");
        case TLE:
            return isFP ? context.builder.CreateFCmpULE(L, R, "FLE") : context.builder.CreateICmpSLE(L, R, "LE");
        case TGT:
            return isFP ? context.builder.CreateFCmpUGT(L, R, "FGT") : context.builder.CreateICmpSGT(L, R, "GT");
        case TGE:
            return isFP ? context.builder.CreateFCmpUGE(L, R, "FGE") : context.builder.CreateICmpSGE(L, R, "GE");
        case TEQ:
            return isFP ? context.builder.CreateFCmpUEQ(L, R, "FEQ") : context.builder.CreateICmpEQ(L, R, "EQ");
        case TNE:
            return isFP ? context.builder.CreateFCmpUNE(L, R, "FEQ") : context.builder.CreateICmpNE(L, R, "NE");
        default:
            return nullptr;
    }
}

Value *NUnaryOperator::codeGen(CodeGenContext &context) {
    auto R = rhs->codeGen(context);
    const bool isFP = R->getType()->isFloatTy() || R->getType()->isDoubleTy();
    switch (op) {
        case TNOT:
            if (isFP) std::cerr << "Compute NOT on FP!\n";
            return context.builder.CreateNot(R, "NOT");
        case TMINUS:
            return isFP ? context.builder.CreateFNeg(R, "FNEG") : context.builder.CreateNeg(R, "NEG");
        default:
            return nullptr;
    }
}

Value *NIdentifier::codeGen(CodeGenContext &context) {
    auto id = context.get(name);
    if (!id || !id->value) {
        std::cerr << "Undeclared value: " << name << std::endl;
        return nullptr;
    }

    if (id->size) {
        return id->value;
    } else return context.builder.CreateLoad(id->value, false, "load");
}

Value *NAssignment::codeGen(CodeGenContext &context) {
    auto id = context.get(lhs.name);
    Value *res;
    if (!id && !allowDecl) {
        std::cerr << "Undeclared value: " << lhs.name << std::endl;
        return nullptr;
    }
    auto val = rhs.codeGen(context);
    auto type = val->getType();
    if (type->isArrayTy() || (type->isPointerTy() && type->getPointerElementType()->isArrayTy())) {
        val->setName(lhs.name);
        res = val;
        if (id && !id->value) id->value = val;
        if (id && id->size && *id->size->begin() == 0) {
            (*(id->size))[0] = val->getType()->getArrayNumElements();
        }
    } else {
        if (id) {
            if (id->value) { context.builder.CreateStore(val, id->value); }
            else {
                id->value = val;
            }
            res = id->value;
        } else {
            res = val;
        }
    }
    return res;
}

Value *NArrayAssignment::codeGen(CodeGenContext &context) {
    auto id = context.get(lhs.name);
    if (!id) {
        std::cerr << "Undeclared value: " << lhs.name << std::endl;
        return nullptr;
    }
    if (!id->size) {
        std::cerr << "Unindexable value: " << lhs.name << std::endl;
        return nullptr;
    }
    auto val = rhs.codeGen(context);
    if (id->dType->getTypeID() != val->getType()->getTypeID()) {
        std::cerr << "Cannot assign ";
        val->getType()->print(errs());
        std::cerr << " to ";
        id->dType->print(errs());
        std::cerr << std::endl;
        return nullptr;
    }

    assert(arrayIndices.size() == id->size->size());
    auto arrDim = *(id->size);
    auto exp = *(arrayIndices.rbegin());
    for (unsigned i = arrayIndices.size() - 1; i >= 1; i--) {
        auto tmp = new NBinaryOperator(new NInteger(std::to_string(arrDim[i])), TMUL, arrayIndices[i - 1]);
        exp = new NBinaryOperator(exp, TPLUS, tmp);
    }
    auto idx = exp->codeGen(context);
    std::vector<Value *> arrV;
    if (!id->value->getType()->isPointerTy())
        arrV.push_back(ConstantInt::get(Type::getInt64Ty(context.llvmContext), 0));
    arrV.push_back(idx);
    auto ptr = context.builder.CreateInBoundsGEP(id->value, makeArrayRef(arrV), "elementPtr");
    return context.builder.CreateAlignedStore(val, ptr, MaybeAlign(4));
}

Value *NClassAssignment::codeGen(CodeGenContext &context) {
    // TODO: class
    return nullptr;
}

Value *NBlock::codeGen(CodeGenContext &context) {
    StatementList::const_iterator it;
    Value *last = nullptr;
    for (it = statements.begin(); it != statements.end(); it++) {
        auto &statement = **it;
        last = (statement).codeGen(context);
    }
    return last;
}

Value *NExpressionStatement::codeGen(CodeGenContext &context) {
    return expression->codeGen(context);
}

Value *NReturnStatement::codeGen(CodeGenContext &context) {
    if (expression) {
        Value *retVal = expression->codeGen(context);
        context.setCurrentReturnValue(retVal);
        context.builder.CreateRet(context.getCurrentReturnValue());
        return retVal;
    } else {
        return context.builder.CreateRetVoid();
    }

}

Value *NVariableDeclaration::codeGen(CodeGenContext &context) {
    if (context.current()->localVal.find(id.name) != context.current()->localVal.end()) {
        std::cerr << "Redeclared value: " << id.name << std::endl;
        return nullptr;
    }
    Value *alloc = nullptr;
    auto dType = context.typeOf(type.name);

    if (!arrDim && type.name != "string") {
        alloc = context.builder.CreateAlloca(dType, nullptr, id.name);
        context.locals()[id.name] = new VarRecord(alloc, dType, nullptr);
        if (assignmentExpr != nullptr) {
            (new NAssignment(id, *assignmentExpr))->codeGen(context);
        }
    } else if (arrDim) {
        auto *arrSize = new std::vector<uint32_t>();
        arraydim arrayDim;
        uint64_t size = arrayDim.calArrayDim(arrDim, arrSize);
        if (assignmentExpr) {
            alloc = (new NAssignment(id, *assignmentExpr, true))->codeGen(context);
            context.locals()[id.name] = new VarRecord(alloc, dType, arrSize);
        } else {
            context.locals()[id.name] = new VarRecord(nullptr, dType, arrSize);
        }
    } else {
        uint32_t size = 0;
        if (assignmentExpr) {
            alloc = (new NAssignment(id, *assignmentExpr, true))->codeGen(context);
        }
        auto sizeV = new std::vector<uint32_t>{size};
        context.locals()[id.name] = new VarRecord(alloc, dType, sizeV);
    }
    return alloc;
}

Value *NFunctionDeclaration::codeGen(CodeGenContext &context) {
    std::vector<Type *> argTypes;
    for (auto item: arguments) {
        if (item->arrDim) {
            argTypes.push_back(context.typeOf(item->type.name)->getPointerTo());
        } else argTypes.push_back(context.typeOf(item->type.name));
    }

    FunctionType *fType = FunctionType::get(context.typeOf(type.name), makeArrayRef(argTypes), false);
    Function *function = Function::Create(fType, GlobalValue::InternalLinkage, id.name,
                                                      context.module);
    BasicBlock *bBlock = BasicBlock::Create(context.llvmContext, id.name + "_entry", function, nullptr);
    context.push(bBlock);
    context.builder.SetInsertPoint(bBlock);

    Function::arg_iterator argsValues = function->arg_begin();
    Value *argumentValue;

    for (auto item: arguments) {
        auto alloc = item->codeGen(context);
        argumentValue = &*argsValues++;
        argumentValue->setName(item->id.name);

        if (alloc) {
            context.builder.CreateStore(argumentValue, alloc, false);
        } else {
            context.current()->localVal[item->id.name]->value = argumentValue;
        }
    }

    block.codeGen(context);
    if (type.name == "void") {
        context.builder.CreateRetVoid();
    } else {
        if (context.getCurrentReturnValue() == nullptr) {
            std::cerr << "function needs return value!\n";
            return nullptr;
        }
    }
    context.pop();
    context.builder.SetInsertPoint(context.current()->block);
    context.locals()[id.name] = new VarRecord(function, fType, nullptr);
    return function;
}

Value *NFunctionCall::codeGen(CodeGenContext &context) {
    Function *function = context.module->getFunction(id.name);
    if (function == nullptr) {
        std::cerr << "no such function " << id.name << std::endl;
    }
    std::vector<Value *> args;

    auto *tmp = new std::vector<uint32_t>();
    bool flag = false;
    for (auto item: params) {
        if (id.name == "scanf" && item != params[0]) {
            auto target = context.get(dynamic_cast<NIdentifier *>(item)->name);
            if (!target->size) {
                context.get(dynamic_cast<NIdentifier *>(item)->name)->size = tmp;
                flag = true;
            }
        }
        auto val = item->codeGen(context);
        if (val->getType()->isArrayTy())
            val = context.builder.CreateBitCast(val, val->getType()->getArrayElementType()->getPointerTo());
        else if (val->getType()->isPointerTy() && val->getType()->getPointerElementType()->isArrayTy()) {
            val = context.builder.CreateBitCast(
                    val, val->getType()->getPointerElementType()->getArrayElementType()->getPointerTo());
        }
        args.push_back(val);
        if (id.name == "scanf" && item != params[0] && flag) {
            flag = false;
            context.get(dynamic_cast<NIdentifier *>(item)->name)->size = nullptr;
        }
    }
    delete tmp;

    return context.builder.CreateCall(function, args,
                                      function->getFunctionType()->getReturnType()->isVoidTy() ? "" : "call");
}

Value *NArrayElement::codeGen(CodeGenContext &context) {
    auto arr = context.get(id.name);
    if (!arr) {
        std::cerr << "Undeclared value: " << id.name << std::endl;
        return nullptr;
    }
    if (!arr->size) {
        std::cerr << "Unindexable value: " << id.name << std::endl;
        return nullptr;
    }

//    assert(arrayIndices.size() == arr->size->size());
    auto arrDim = *(arr->size);
    auto exp = *(arrayIndices.rbegin());
    for (unsigned i = arrayIndices.size() - 1; i >= 1; i--) {
        auto tmp = new NBinaryOperator(new NInteger(std::to_string(arrDim[i])), TMUL, arrayIndices[i - 1]);
        exp = new NBinaryOperator(exp, TPLUS, tmp);
    }
    auto idx = exp->codeGen(context);
    std::vector<Value *> arrV;
    if (!arr->value->getType()->isPointerTy())
        arrV.push_back(ConstantInt::get(Type::getInt64Ty(context.llvmContext), 0));
    arrV.push_back(idx);
    auto ptr = context.builder.CreateInBoundsGEP(arr->value, makeArrayRef(arrV), "elementPtr");
    return context.builder.CreateAlignedLoad(ptr, MaybeAlign(4));
}

Value *NIfStatement::codeGen(CodeGenContext &context) {
    Value *condValue = condition->codeGen(context);
    if (!condValue)
        return nullptr;

    condValue = context.castToBoolean(condValue);

    Function *function = context.builder.GetInsertBlock()->getParent(); // the function where if statement is in

    BasicBlock *thenBB = BasicBlock::Create(context.llvmContext, "then", function);
    BasicBlock *elseBB;
    if (elseBlock)
        elseBB = BasicBlock::Create(context.llvmContext, "else", function);
    BasicBlock *afterBB = BasicBlock::Create(context.llvmContext, "afterIf", function);

    if (elseBlock) {
        context.builder.CreateCondBr(condValue, thenBB, elseBB);
    } else {
        context.builder.CreateCondBr(condValue, thenBB, afterBB);
    }

    context.builder.SetInsertPoint(thenBB);
    this->thenBlock->codeGen(context);

    context.builder.CreateBr(afterBB);

    if (elseBlock) {
        context.builder.SetInsertPoint(elseBB);
        elseBlock->codeGen(context);
        context.builder.CreateBr(afterBB);
    }

    context.builder.SetInsertPoint(afterBB);
    return nullptr;
}

Value *NForStatement::codeGen(CodeGenContext &context) {
    Function *function = context.builder.GetInsertBlock()->getParent();

    BasicBlock *forLoop = BasicBlock::Create(context.llvmContext, "forLoop", function);
    BasicBlock *forCond = BasicBlock::Create(context.llvmContext, "forCon", function);
    BasicBlock *after = BasicBlock::Create(context.llvmContext, "afterFor", function);

    if (init)
        init->codeGen(context);
    context.builder.CreateBr(forCond);
    context.inLoop++;
    auto prevMerge = context.curMerge;
    auto prevCond = context.curCond;
    context.curMerge = after;
    context.curCond = forCond;

    context.builder.SetInsertPoint(forLoop);
    block->codeGen(context);
    if (increment) increment->codeGen(context);
    context.builder.CreateBr(forCond);

    context.builder.SetInsertPoint(forCond);
    auto condVal = context.castToBoolean(condition->codeGen(context));
    context.builder.CreateCondBr(condVal, forLoop, after);

    context.builder.SetInsertPoint(after);

    context.curMerge = prevMerge;
    context.curCond = prevCond;
    context.inLoop--;
    return nullptr;
}

Value *NNullstatement::codeGen(CodeGenContext &context)
{
    return nullptr;
}
Value *NWhileStatement::codeGen(CodeGenContext &context) {
    Function *function = context.builder.GetInsertBlock()->getParent();

    BasicBlock *whileLoop = BasicBlock::Create(context.llvmContext, "whileLoop", function);
    BasicBlock *whileCond = BasicBlock::Create(context.llvmContext, "whileCond", function);
    BasicBlock *after = BasicBlock::Create(context.llvmContext, "afterWhile", function);

    context.builder.CreateBr(whileCond);
    context.inLoop++;
    auto prevMerge = context.curMerge;
    auto prevCond = context.curCond;
    context.curMerge = after;
    context.curCond = whileCond;

    context.builder.SetInsertPoint(whileLoop);
    block->codeGen(context);
    context.builder.CreateBr(whileCond);

    context.builder.SetInsertPoint(whileCond);
    auto condVal = context.castToBoolean(condition->codeGen(context));
    context.builder.CreateCondBr(condVal, whileLoop, after);

    context.builder.SetInsertPoint(after);

    context.curMerge = prevMerge;
    context.curCond = prevCond;
    context.inLoop--;
    return nullptr;
}

Value *NDoWhileStatement::codeGen(CodeGenContext &context) {
    Function *function = context.builder.GetInsertBlock()->getParent();

    BasicBlock *whileLoop = BasicBlock::Create(context.llvmContext, "doWhileLoop", function);
    BasicBlock *whileCond = BasicBlock::Create(context.llvmContext, "doWhileCond", function);
    BasicBlock *after = BasicBlock::Create(context.llvmContext, "afterDoWhile", function);

    context.builder.CreateBr(whileLoop);
    context.inLoop++;
    auto prevMerge = context.curMerge;
    auto prevCond = context.curCond;
    context.curMerge = after;
    context.curCond = whileCond;

    context.builder.SetInsertPoint(whileLoop);
    block->codeGen(context);
    context.builder.CreateBr(whileCond);

    context.builder.SetInsertPoint(whileCond);
    auto condVal = context.castToBoolean(condition->codeGen(context));
    context.builder.CreateCondBr(condVal, whileLoop, after);

    context.builder.SetInsertPoint(after);

    context.curMerge = prevMerge;
    context.curCond = prevCond;
    context.inLoop--;
    return nullptr;
}

Value *NBreakStatement::codeGen(CodeGenContext &context) {
    if (context.inLoop) {
        context.builder.CreateBr(context.curMerge);
    } else {
        std::cerr << "Use break outsize loop!\n";
    }
    return nullptr;
}

Value *NContinueStatement::codeGen(CodeGenContext &context) {
    if (context.inLoop) {
        context.builder.CreateBr(context.curCond);
    } else {
        std::cerr << "Use continue outsize loop!\n";
    }
    return nullptr;
}

Value *NIncOperator::codeGen(CodeGenContext &context) {
    auto R = rhs->codeGen(context);
    auto ptr = context.get(dynamic_cast<NIdentifier *>(rhs)->name)->value;
    auto type = R->getType();
    assert(type->isIntegerTy() || type->isDoubleTy() || type->isFloatTy());
    bool isFP = !type->isIntegerTy();
    auto L = isFP ? ConstantFP::get(type, 1.0) : ConstantInt::get(type, 1);
    auto res = isFP ? context.builder.CreateFAdd(L, R, "FTINC") : context.builder.CreateAdd(L, R, "TINC");

    context.builder.CreateStore(res, ptr);
    return isPrefix ? res : R;
}

Value *NDecOperator::codeGen(CodeGenContext &context) {
    auto R = rhs->codeGen(context);
    auto ptr = context.get(dynamic_cast<NIdentifier *>(rhs)->name)->value;
    auto type = R->getType();
    assert(type->isIntegerTy() || type->isDoubleTy() || type->isFloatTy());
    bool isFP = !type->isIntegerTy();
    auto L = isFP ? ConstantFP::get(type, 1.0) : ConstantInt::get(type, 1);
    auto res = isFP ? context.builder.CreateFSub(R, L, "FDEC") : context.builder.CreateSub(R, L, "DEC");
    context.builder.CreateStore(res, ptr);
    return isPrefix ? res : R;
}
Value *NStructAssignment::codeGen(CodeGenContext &context)
{
    auto varRecPtr = context.get(this->structmember.id.name);
    auto structPtr = context.builder.CreateLoad(varRecPtr->value, "structPtr");
    if ( !structPtr->getType()->isStructTy())
    {
        std::cout<<"not a struct type!"<<std::endl;
        return nullptr;
    }
    std::string structname = structPtr->getType()->getStructName().str();
    int memberindex = context.getstructmemberindex(structname,this->structmember.member.name);
    auto value = this->expression->codeGen(context);
    std::vector<Value*> indices;
    indices.push_back(ConstantInt::get(context.typeOf("int"),0,false));
    indices.push_back(ConstantInt::get(context.typeOf("int"),(uint64_t)memberindex,false));
    auto ptr = context.builder.CreateInBoundsGEP(varRecPtr->value,indices,"structmemberPtr");
    return context.builder.CreateStore(value,ptr);
}
Value *NStructMember::codeGen(CodeGenContext &context)
{
    auto varRecPtr = context.get(this->id.name);
    auto structPtr = context.builder.CreateLoad(varRecPtr->value, "structPtr");
    if(!structPtr->getType()->isStructTy()){
        std::cout<<"error!"<<std::endl;
        return nullptr;
    }
    std::string structname = structPtr->getType()->getStructName().str();
    int memberindex = context.getstructmemberindex(structname,this->member.name);
    std::vector<Value*> indices;
    indices.push_back(ConstantInt::get(context.typeOf("int"),0,false));
    indices.push_back(ConstantInt::get(context.typeOf("int"),(uint64_t)memberindex,false));
    auto ptr = context.builder.CreateInBoundsGEP(varRecPtr->value,indices,"memberPtr");
    return context.builder.CreateLoad(ptr);
}
Value *NStructdec::codeGen(CodeGenContext &context)
{
    std::vector <Type* > memberTypes;

    auto structType = StructType::create(context.llvmContext, this->structid.name);
    
    auto alloc = context.builder.CreateAlloca(structType, nullptr, this->structid.name);

    for(auto& member: this->members){
        memberTypes.push_back(context.typeOf(member->type.name));
        context.structmembers[this->structid.name].push_back(std::make_pair(member->type.name,member->id.name));
    }
    structType->setBody(memberTypes);

    context.locals()[this->structid.name] = new VarRecord(alloc, structType, nullptr);

    return nullptr;

}
uint64_t arraydim::calArrayDim(std::vector<std::string* >* arrDim, std::vector<uint32_t>* arrSize) {
        uint64_t size = 1;
        for (auto dim: *arrDim) {
            uint32_t n = strtol(dim->c_str(), nullptr, 10);
            size *= n;
            arrSize->push_back(n);
        }
        return size;
}

uint64_t arraydim::calArrayDim(std::vector<std::string* >* arrDim) {
        uint64_t size = 1;
        for (auto dim: *arrDim) {
            uint32_t n = strtol(dim->c_str(), nullptr, 10);
            size *= n;
        }
        return size;
}
#endif 

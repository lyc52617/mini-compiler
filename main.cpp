#include <iostream>
#include "codeGen.h"
#include "ast.h"

extern FILE *yyin;

extern int yyparse();

extern NBlock *programBlock;
void createCoreFunctions(CodeGenContext &context);
void createPrintf(CodeGenContext& context); 
void createScanf(CodeGenContext& context);
void createGets(CodeGenContext& context);
int main(int argc, char **argv) {
    if (argc == 0) {
        std::cerr << "Invalid Param!\n";
        std::exit(1);
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        printf("couldn't open file for reading\n");
        exit(-1);
    }
    yyin = fp;
    int parseErr = yyparse();
    if (parseErr != 0) {
        printf("couldn't complete lex parse\n");
        exit(-1);
    }
    fclose(fp);
    llvm::InitializeNativeTarget();
    llvm::InitializeNativeTargetAsmPrinter();
    llvm::InitializeNativeTargetAsmParser();
    CodeGenContext context;
    createCoreFunctions(context);
    context.generateCode(*programBlock, "test/output.ll");
    return 0;
}

void createCoreFunctions(CodeGenContext& context) {
    createPrintf(context);
    createScanf(context);
    createGets(context);
}
void createPrintf(CodeGenContext& context) {
    std::vector<llvm::Type*> argTypes;
    argTypes.push_back(context.typeOf("string"));
    auto fType = llvm::FunctionType::get(
            context.typeOf("int"), argTypes, true);
    auto printf = llvm::Function::Create(
            fType, llvm::Function::ExternalLinkage,
            llvm::Twine("printf"),
            context.module
    );
    printf->setCallingConv(llvm::CallingConv::C);
}

void createScanf(CodeGenContext& context) {
    std::vector<llvm::Type*> argTypes;
    argTypes.push_back(context.typeOf("string"));
    auto fType = llvm::FunctionType::get(
            context.typeOf("int"), argTypes, true);
    auto printf = llvm::Function::Create(
            fType, llvm::Function::ExternalLinkage,
            llvm::Twine("scanf"),
            context.module
    );
    printf->setCallingConv(llvm::CallingConv::C);
}

void createGets(CodeGenContext& context) {
    std::vector<llvm::Type*> argTypes;
    auto fType = llvm::FunctionType::get(
            context.typeOf("int"), argTypes, true);
    auto printf = llvm::Function::Create(
            fType, llvm::Function::ExternalLinkage,
            llvm::Twine("gets"),
            context.module
    );
    printf->setCallingConv(llvm::CallingConv::C);
}

%{
    #include "treenode.h"
    #include <cstdio>
    #include <cstdlib>
    #define YYERROR_VERBOSE 1
	BlockNode *programBlock; // the root
	extern int yylex();
    extern int yylineno;
	void yyerror(const char *s) { std::printf("Error: %s", s); }
    void printError(int lineno, string s) { std::printf(" at: line: %d\n", lineno); }
%}

%error-verbose

%union {
	ASTnode *node
	NBlock *block;
	NExpression *expression;
	NStatement *statement;
	NIdentifier *identifier;
	VariableDeclarationNode *variableDeclaration;
	std::vector<shared_ptr<NVariableDeclaration>>* varvec;
	std::vector<shared_ptr<NExpression>>* exprvec;
	Narrayelement *element;
	std::string *string;
	int token;
}

%token <string> TIDENTIFIER TINTEGER TDOUBLE TYINT TYDOUBLE TYFLOAT TYCHAR TYBOOL TYVOID TYSTRING TEXTERN TLITERAL TCHAR TSTRING
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT TSEMICOLON TLBRACKET TRBRACKET TQUOTATION
%token <token> TPLUS TMINUS TMUL TDIV TAND TOR TXOR TMOD TNEG TNOT TSHIFTL TSHIFTR
%token <token> TIF TELSE TFOR TWHILE TRETURN TSTRUCT

%type <index> array_index
%type <ident> ident primary_typename array_typename struct_typename typename
%type <expr> numeric expr assign
%type <varvec> func_decl_args struct_members
%type <exprvec> call_args
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl struct_decl if_stmt for_stmt while_stmt
%type <token> comparison

%left TPLUS TMINUS
%left TMUL TDIV TMOD

%start program

%%




%%




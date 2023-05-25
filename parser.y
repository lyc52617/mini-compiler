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

%token <string> TIDENTIFIER TINTEGER TDOUBLE TCHAR TSTRING TBOOL TFLOAT TYINT TYDOUBLE TYFLOAT TYCHAR TYBOOL TYVOID TYSTRING TEXTERN TLITERAL TCHAR TSTRING
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT TSEMICOLON TLBRACKET TRBRACKET TQUOTATION
%token <token> TPLUS TMINUS TMUL TDIV TAND TOR TXOR TMOD TNEG TNOT TSHIFTL TSHIFTR
%token <token> TIF TELSE TFOR TWHILE TRETURN TSTRUCT

%type <index> array_index
%type <ident> ident primary_typename array_typename struct_typename typename
%type <expr> literal expr assign
%type <varvec> func_decl_args struct_members
%type <exprvec> call_args
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl struct_decl if_stmt for_stmt while_stmt
%type <token> comparison

%left TPLUS TMINUS
%left TMUL TDIV TMOD

%start program

%%
program : stmts { programBlock = $1; };

stmts : stmt { $$ = new NBlock(); $$->statements->push_back(shared_ptr<NStatement>($1)); }
			| stmts stmt { $1->statements->push_back(shared_ptr<NStatement>($2)); }
			;
stmt : var_decl TSEMICOLON | func_decl TSEMICOLON| struct_decl TSEMICOLON
		 | expr TSEMICOLON{ $$ = new NExpressionStatement(shared_ptr<NExpression>($1)); }
		 | TRETURN expr TSEMICOLON{ $$ = new NReturnStatement(shared_ptr<NExpression>($2)); }
		 | if_stmt TSEMICOLON
		 | if_else_stmt TSEMICOLON
		 | for_stmt TSEMICOLON
		 | while_stmt TSEMICOLON
		 ;
block : TLBRACE stmts TRBRACE { $$ = $2; }
			| TLBRACE TRBRACE { $$ = new NBlock(); }
			;

var_decl : typename ident { $$ = new NVariableDeclaration(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($2), nullptr); }
				 | typename ident TEQUAL expr { $$ = new NVariableDeclaration(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($2), shared_ptr<NExpression>($4)); }
				 | typename ident TEQUAL TLBRACKET call_args TRBRACKET {
					 $$ = new Narrayinitialize(make_shared<NVariableDeclaration>(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($2), nullptr), shared_ptr<ExpressionList>($5));
				 }
				 ;
func_decl : typename ident TLPAREN func_decl_args TRPAREN block
				{ $$ = new NFunctionDeclaration(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($2), shared_ptr<VariableList>($4), shared_ptr<NBlock>($6));  }
			| TEXTERN typename ident TLPAREN func_decl_args TRPAREN { $$ = new NFunctionDeclaration(shared_ptr<NIdentifier>($2), shared_ptr<NIdentifier>($3), shared_ptr<VariableList>($5), nullptr, true); }
			;
typename : primary_typename { $$ = $1; }
			| array_typename { $$ = $1; }
			| struct_typename { $$ = $1; }
			;
primary_typename : TYINT { $$ = new NIdentifier(*$1); $$->isType = true;  delete $1; }
					| TYDOUBLE { $$ = new NIdentifier(*$1); $$->isType = true; delete $1; }
					| TYFLOAT { $$ = new NIdentifier(*$1); $$->isType = true; delete $1; }
					| TYCHAR { $$ = new NIdentifier(*$1); $$->isType = true; delete $1; }
					| TYBOOL { $$ = new NIdentifier(*$1); $$->isType = true; delete $1; }
					| TYVOID { $$ = new NIdentifier(*$1); $$->isType = true; delete $1; }
					| TYSTRING { $$ = new NIdentifier(*$1); $$->isType = true; delete $1; }
					;
array_typename : primary_typename TLBRACKET TINTEGER TRBRACKET { 
					$1->isArray = true; 
					$1->arraySize->push_back(make_shared<NInteger>(atol($3->c_str()))); 
					$$ = $1; 
				}
				| array_typename TLBRACKET TINTEGER TRBRACKET {
					$1->arraySize->push_back(make_shared<NInteger>(atol($3->c_str())));
					$$ = $1;
				}

func_decl_args : /* blank */ { $$ = new VariableList(); }
							 | var_decl { $$ = new VariableList(); $$->push_back(shared_ptr<NVariableDeclaration>($<var_decl>1)); }
							 | func_decl_args TCOMMA var_decl { $1->push_back(shared_ptr<NVariableDeclaration>($<var_decl>3)); }
							 ;
ident : TIDENTIFIER { $$ = new NIdentifier(*$1); delete $1; }

expr : 	assign { $$ = $1; }
		 | ident TLPAREN call_args TRPAREN { $$ = new NMethodCall(shared_ptr<NIdentifier>($1), shared_ptr<ExpressionList>($3)); }
		 | ident { $<ident>$ = $1; }
		 | ident TDOT ident { $$ = new NStructMember(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($3)); }
		 | literal
		 | expr comparison expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TMOD expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TMUL expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TDIV expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TPLUS expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TMINUS expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | TLPAREN expr TRPAREN { $$ = $2; }
		 | TMINUS expr { $$ = nullptr; /* TODO */ }
		 | array_index { $$ = $1; }
			;
literal: TINTEGER { $$ = new NInteger(atol($1->c_str())); }
			| TDOUBLE { $$ = new NDouble(atof($1->c_str())); }
			| TFLOAT { $$ = new NFloat(atof($1->c_str())); }
			| TBOOL { $$ = new NDouble($1); }
			| TCHAR { $$ = new NDouble($1->c_str()); }
			| TSTRING { $$ = new NDouble($1); }
%%




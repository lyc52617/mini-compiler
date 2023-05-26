%{
    #include "ast.h"
    #include <cstdio>
    #include <cstdlib>
	#include <iostream>
	#include <string>
	#include <vector>
	#include <memory>
    extern int yylex();
	extern int countline;
	extern int countchar;
	NBlock *programBlock; // the root
	void yyerror(const char *s) { std::cout<< "Unexpected error at line" << countline <<" pos "<<countchar<<std::endl; }
%}


%union {
	ASTnode *node;
	NBlock *block;
	NExpression *expression;
	NStatement *statement;
	NIdentifier *identifier;
	NVariableDeclaration* var_decl;
	VariableList *varvec;
	ExpressionList *exprvec;
	Narrayelement *element;
	std::string *string;
	int token;
}

%token <string> TIDENTIFIER TINTEGER TDOUBLE TCHAR TSTRING TBOOL TFLOAT TYINT TYDOUBLE TYFLOAT TYCHAR TYBOOL TYVOID TYSTRING TEXTERN TLITERAL
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT TSEMICOLON TLBRACKET TRBRACKET TQUOTATION
%token <token> TPLUS TMINUS TMUL TDIV TAND TOR TMOD TNEG TNOT TSHIFTL TSHIFTR
%token <token> TIF TELSE TFOR TWHILE TRETURN TBREAK TSTRUCT

%type <element> array_index
%type <identifier> ident primary_typename array_typename struct_typename typename
%type <expression> literal expr assign muldiv bitop term
%type <varvec> func_decl_args struct_member
%type <exprvec> call_args
%type <block> program stmts block
%type <statement> stmt var_decl func_decl struct_decl if_stmt for_stmt while_stmt

%left TPLUS TMINUS TCEQ TCNE TCLT TCLE TCGT TCGE 
%left TMUL TDIV TMOD TOR TXOR TNEG TNOT

%start program

%%
program : stmts { programBlock = $1; };

stmts : stmt { $$ = new NBlock(); $$->statements->push_back(shared_ptr<NStatement>($1)); }
			| stmts stmt { $1->statements->push_back(shared_ptr<NStatement>($2)); }
			;
stmt : var_decl TSEMICOLON | func_decl TSEMICOLON| struct_decl TSEMICOLON
		 | expr TSEMICOLON{ $$ = new NExpressionStatement(shared_ptr<NExpression>($1)); }
		 | TRETURN expr TSEMICOLON{ $$ = new Nreturn(shared_ptr<NExpression>($2)); }
		 | if_stmt TSEMICOLON { $$ = $1; }
		 | for_stmt TSEMICOLON { $$ = $1; }
		 | while_stmt TSEMICOLON { $$ = $1; }
		 | TBREAK TSEMICOLON { $$ = new Nbreak(); }
		 | TSEMICOLON {$$ = nullptr;}
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
				{ $$ = new NFunctionDeclaration(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($2), *$4, shared_ptr<NBlock>($6));  }
				;
typename : primary_typename { $$ = $1; }
			| array_typename { $$ = $1; }
			| struct_typename { $$ = $1; }
			;
primary_typename : TYINT { $$ = new NIdentifier(*$1,"int");delete $1; }
					| TYDOUBLE { $$ = new NIdentifier(*$1,"double"); $$->type = true; delete $1; }
					| TYFLOAT { $$ = new NIdentifier(*$1,"float"); $$->type = true; delete $1; }
					| TYCHAR { $$ = new NIdentifier(*$1,"char"); $$->type = true; delete $1; }
					| TYBOOL { $$ = new NIdentifier(*$1,"bool"); $$->type = true; delete $1; }
					| TYVOID { $$ = new NIdentifier(*$1,"void"); $$->type = true; delete $1; }
					| TYSTRING { $$ = new NIdentifier(*$1,"string"); $$->type = true; delete $1; }
					;
array_typename : primary_typename TLBRACKET TINTEGER TRBRACKET { 
					$1->isarray = true; 
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
		| TLPAREN expr TRPAREN { $$ = $2; }
		 | ident TLPAREN call_args TRPAREN { $$ = new NFunctionCall(shared_ptr<NIdentifier>($1), shared_ptr<ExpressionList>($3)); }
		 | ident { $<identifier>$ = $1; }
		 | ident TDOT ident { $$ = new NStructmember(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($3)); }
		 | expr TAND expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TOR expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | literal
		 | term
		 | TMINUS expr { $$ = nullptr;}
		 | array_index { $$ = $1; }
		;
muldiv:		expr TMOD expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TMUL expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TDIV expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 ;
array_index : ident TLBRACKET expr TRBRACKET 
				{ $$ = new Narrayelement(shared_ptr<NIdentifier>($1), shared_ptr<NExpression>($3)); }
				| array_index TLBRACKET expr TRBRACKET 
					{ 	
						$1->expressions->push_back(shared_ptr<NExpression>($3));
						$$ = $1;
					};
literal: TINTEGER { $$ = new NInteger(atol($1->c_str())); }
			| TDOUBLE { $$ = new NDouble(atof($1->c_str())); }
			| TFLOAT { $$ = new NFloat(atof($1->c_str())); }
			| TBOOL { $$ = new NBool(*$1); }
			| TCHAR { $$ = new NChar(*$1); }
			| TSTRING { $$ = new NString(*$1); }

assign : 	 ident TEQUAL expr { $$ = new NAssignment(shared_ptr<NIdentifier>($1), shared_ptr<NExpression>($3)); }
			| array_index TEQUAL expr {
				$$ = new Narrayelementassign(shared_ptr<Narrayelement>($1), shared_ptr<NExpression>($3));
			}
			| ident TDOT ident TEQUAL expr {
				auto member = make_shared<NStructmember>(shared_ptr<NIdentifier>($1), shared_ptr<NIdentifier>($3)); 
				$$ = new Nstructassign(member, shared_ptr<NExpression>($5)); 
			}
			;
call_args : /* blank */ { $$ = new ExpressionList(); }
					| expr { $$ = new ExpressionList(); $$->push_back(shared_ptr<NExpression>($1)); }
					| call_args TCOMMA expr { $1->push_back(shared_ptr<NExpression>($3)); }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
					;
				 
bitop: 	expr TPLUS expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TMINUS expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | muldiv
		 ;
term:	expr TCNE expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TCEQ expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TCGE expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TCLE expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TCLT expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | expr TCGT expr { $$ = new NBinaryOperator(shared_ptr<NExpression>($1), $2, shared_ptr<NExpression>($3)); }
		 | bitop
if_stmt: TIF TLPAREN expr TRPAREN block{ $$ = new Nifelse(shared_ptr<NExpression>($3), shared_ptr<NBlock>($5));}
		| TIF TLPAREN expr TRPAREN block TELSE block {$$ = new Nifelse(shared_ptr<NExpression>($3), shared_ptr<NBlock>($5),shared_ptr<NBlock>($7));}
		| TIF TLPAREN expr TRPAREN block TELSE if_stmt
		{auto ifelse = new NBlock();ifelse->statements->push_back(shared_ptr<NStatement>($7));$$ = new Nifelse(shared_ptr<NExpression>($3), shared_ptr<NBlock>($5),shared_ptr<NBlock>(ifelse));};

while_stmt: TWHILE TLPAREN expr TRPAREN block{
		$$ = new Nwhile(shared_ptr<NBlock>($5),shared_ptr<NExpression>($3));};
		

for_stmt:TFOR TLPAREN expr TSEMICOLON expr TSEMICOLON expr TRPAREN block { $$ = new Nforloop( shared_ptr<NExpression>($3), shared_ptr<NExpression>($5), shared_ptr<NExpression>($7),shared_ptr<NBlock>($9)); }

struct_typename: TSTRUCT ident {
				$2->type = "struct";
				$$ = $2;
			}
struct_decl : TSTRUCT ident TLBRACE struct_member TRBRACE {$$ = new Nstructdeclaration(shared_ptr<NIdentifier>($2), *$4); }

struct_member : { $$ = new VariableList(); }
				| var_decl { $$ = new VariableList(); $$->push_back(shared_ptr<NVariableDeclaration>($<var_decl>1)); }
				| struct_member var_decl { $1->push_back(shared_ptr<NVariableDeclaration>($<var_decl>2)); }
				;
%%




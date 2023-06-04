%{
#include <iostream>
#include <string>
#include <vector>
#include "ast.h"
extern int currentchar;
extern int currentline;
extern std::string curToken;
extern int yylex();
void yyerror(const char *s){
    std::cout << "Token: " << curToken << std::endl
        << "Error: " << s << " at " << currentline << ":" << currentchar << std::endl;
    std::exit(1);
}

NBlock *programBlock;

%}

%union {
    std::string* val;
    std::string* type;
    Node *node;
    NBlock *block;
    NExpression *expr;
	NStructMember* stmb;
    NStatement *stmt;
    NIdentifier *id;
    NVariableDeclaration *varDecl;
    VariableList *varVec;
    ExpressionList *expVec;
    ArrayDimension *arrDim;
    int32_t token;
}

%token <token> TLSB TRSB TLMB TRMB TLLB TRLB TDOT TCOLON TSEMI
%token <token> TPLUS TMINUS TMUL TDIV TMOD TXOR TAND TOR TQUOTE TSTRUCT
%token <token> TGT TGE TLT TLE TNE TEQ TASSIGN TNOT TCOMMA TINC TDEC

%token <token> TIF TELSE TWHILE TFOR TDO TBREAK TCONTINUE
%token <token> TSWITCH TCASE TDEFAULT 
%token <token> TINT TCHAR TDOUBLE TFLOAT TBOOLEAN TCONST
%token <token> TVOID TENUM TSTRING TNEW TTHIS
%token <token> TRETURN
%token <val> TID

%token <val> TINTEGER TBOOL TDNUMBER TFNUMBER TCHARACTER TSTR

%type <block> program blockedStmt stmts
%type <stmt> stmt funcDecl decl struct_decl  ifStmt forStmt nullableStmt
%type <stmt> whileStmt doWhileStmt 
%type <id> type id basicType
%type <expr> exp expr term factor literal call assign 
%type <varVec> funcdecllist structmember
%type <expVec> paramList arrayIndices literalList literalArray
%type <varDecl> idDecl constIdDecl
%type <arrDim> arrayDimensions
%type <stmb> struct_member

%left TPLUS TMINUS TMUL TDIV TMOD TXOR TAND TOR TNOT
%left TGT TGE TLT TLE TNE TEQ
%right TASSIGN

%%

program : stmts { programBlock = $1; }
    ;

stmts : stmts stmt { $1->statements.push_back($2); }
    | stmt { $$ = new NBlock(); $$->statements.push_back($1); }
    ;

stmt : decl TSEMI { $$ = $1; }
	| TSEMI { $$ = new NNullstatement();}
    | ifStmt { $$ = $1; }
    | forStmt { $$ = $1; }
    | whileStmt { $$ = $1; }
    | doWhileStmt TSEMI{ $$ = $1; }
    | assign TSEMI { $$ = new NExpressionStatement($1); }
    | exp TSEMI { $$ = new NExpressionStatement($1); }
    | TBREAK TSEMI { $$ = new NBreakStatement(); }
    | TCONTINUE TSEMI { $$ = new NContinueStatement(); }
    ;

whileStmt : TWHILE TLSB exp TRSB blockedStmt { $$ = new NWhileStatement($3, $5); }
    ;

doWhileStmt : TDO blockedStmt TWHILE TLSB exp TRSB { $$ = new NDoWhileStatement($5, $2); }
    ;

nullableStmt : decl { $$ = $1; }
    | assign { $$ = new NExpressionStatement($1); }
    | exp { $$ = new NExpressionStatement($1); }
    | { $$ = nullptr; }
    ;

ifStmt : TIF TLSB exp TRSB blockedStmt { $$ = new NIfStatement($3, $5); }
    | TIF TLSB exp TRSB blockedStmt TELSE blockedStmt { $$ = new NIfStatement($3, $5, $7); }
    | TIF TLSB exp TRSB blockedStmt TELSE ifStmt { 
        auto elseBlock = new NBlock();
        elseBlock->statements.push_back($7);
        $$ = new NIfStatement($3, $5, elseBlock);
    }
    ;

forStmt : TFOR TLSB nullableStmt TSEMI exp TSEMI nullableStmt TRSB blockedStmt { $$ = new NForStatement($3, $5, $7, $9); }
blockedStmt : TLLB stmts TRLB { $$ = $2; }
    | TLLB TRLB { $$ = new NBlock(); }
    ;

decl : idDecl { $$ = $1; }
    | constIdDecl { $$ = $1; }
    | funcDecl { $$ = $1; }
	| struct_decl {$$ = $1;}
    | TRETURN exp { $$ = new NReturnStatement($2); }
    | TRETURN { $$ = new NReturnStatement(); }
    ;

idDecl : type id { $$ = new NVariableDeclaration(false, *$1, *$2); }
    | type id TASSIGN exp { $$ = new NVariableDeclaration(false, *$1, *$2, $4); }
    | type id arrayDimensions { $$ = new NVariableDeclaration(false, true,$3,*$1, *$2); }
    | type id arrayDimensions TASSIGN exp { $$ = new NVariableDeclaration(false, true,$3,*$1, *$2, $5); }
    ;

literalArray : TLLB literalList TRLB { $$ = $2; }
    ;
literalList : literalList TCOMMA literal { $$->push_back($3); }
    | literal { $$ = new ExpressionList(); $$->push_back($1); }
    ;
 
constIdDecl : TCONST type id { $$ = new NVariableDeclaration(true, *$2, *$3); }
    | TCONST type id TASSIGN exp { $$ = new NVariableDeclaration(true, *$2, *$3, $5); }
    ;

funcDecl : type id TLSB funcdecllist TRSB blockedStmt {
    $$ = new NFunctionDeclaration(*$1, *$2, *$4, *$6); }
    ;
struct_decl : TSTRUCT id TLLB structmember TRLB
{
	$$ = new NStructdec(*$2,*$4);
}	;
structmember : idDecl TSEMI{$$ = new VariableList(); $$->push_back($1); }
	| constIdDecl TSEMI{ $$ = new VariableList(); $$->push_back($1);}
	| structmember idDecl TSEMI{$1->push_back($2);}
	| structmember constIdDecl TSEMI{$1->push_back($2); }
	;
funcdecllist : idDecl { $$ = new VariableList(); $$->push_back($1); }
    | constIdDecl { $$ = new VariableList(); $$->push_back($1); }
    | funcdecllist TCOMMA constIdDecl { $1->push_back($3); }
    | funcdecllist TCOMMA idDecl { $1->push_back($3); }
    | { $$ = new VariableList(); }
    ;

exp : expr
    | exp TGE expr { $$ = new NBinaryOperator($1, $2, $3); }
    | exp TGT expr { $$ = new NBinaryOperator($1, $2, $3); }
    | exp TLE expr { $$ = new NBinaryOperator($1, $2, $3); }
    | exp TLT expr { $$ = new NBinaryOperator($1, $2, $3); }
    | exp TNE expr { $$ = new NBinaryOperator($1, $2, $3); }
    | exp TEQ expr { $$ = new NBinaryOperator($1, $2, $3); }
    ;
expr : expr TPLUS term { $$ = new NBinaryOperator($1, $2, $3); }
    | expr TMINUS term { $$ = new NBinaryOperator($1, $2, $3); }
    | expr TOR term { $$ = new NBinaryOperator($1, $2, $3); }
    | term { $$ = $1; }
    ;
term : term TMUL factor { $$ = new NBinaryOperator($1, $2, $3); }
    | term TDIV factor { $$ = new NBinaryOperator($1, $2, $3); }
    | term TAND factor { $$ = new NBinaryOperator($1, $2, $3); }
    | term TMOD factor { $$ = new NBinaryOperator($1, $2, $3); }
    | term TXOR factor { $$ = new NBinaryOperator($1, $2, $3); }
    | factor { $$ = $1; }
    ;
factor : literal { $$ = $1; }
    | id { $$ = $1; }
    | call { $$ = $1; }
    | TLSB exp TRSB { $$ = $2; }
    | TNOT factor { $$ = new NUnaryOperator($1, $2); }
    | TMINUS factor { $$ = new NUnaryOperator($1, $2); }
    | TINC id { $$ = new NIncOperator($1, $2, true); }
    | TDEC id { $$ = new NDecOperator($1, $2, true); }
    | id TINC { $$ = new NIncOperator($2, $1, false); }
    | id TDEC { $$ = new NDecOperator($2, $1, false); }
    | struct_member {$$ = $1;}
    | id arrayIndices { $$ = new NArrayElement(*$1, *$2); }
    | type literalArray arrayDimensions { $$ = new NArray($1, $3, $2); }
    | TNEW type arrayDimensions { $$ = new NArray($2, $3); }
    ;
struct_member : id TDOT id {$$ = new NStructMember(*$1,*$3); }
arrayDimensions : arrayDimensions TLMB TINTEGER TRMB { $$->push_back($3); }
    | TLMB TINTEGER TRMB { $$ = new ArrayDimension(); $$->push_back($2); }
    ;
arrayIndices : arrayIndices TLMB exp TRMB { $1->push_back($3); }
    | TLMB exp TRMB { $$ = new ExpressionList(); $$->push_back($2); }
    ;
call : id TLSB TRSB { $$ = new NFunctionCall(*$1, *(new ExpressionList())); }
    | id TLSB paramList TRSB { $$ = new NFunctionCall(*$1, *$3); }
    ;
assign : id TASSIGN exp { $$ = new NAssignment(*$1, *$3); }
    | id arrayIndices TASSIGN exp { $$ = new NArrayAssignment(*$1, *$2, *$4); }
	| struct_member TASSIGN exp{$$ = new NStructAssignment(*$1,$3);}
    ;
paramList : exp { $$ = new ExpressionList(); $$->push_back($1); }
    | paramList TCOMMA exp { $$->push_back($3); }
    ;
literal : TINTEGER { $$ = new NInteger(*$1); }
    | TBOOL { $$ = new NBoolean(*$1); }
    | TSTR { $$ = new NString(*$1); }
    | TDNUMBER { $$ = new NDouble(*$1); }
    | TFNUMBER { $$ = new NFloat(*$1); }
    | TCHARACTER { $$ = new NChar(*$1); }
    ;

type : id { $$ = $1; }
    | basicType { $$ = $1; }
	| TSTRUCT id {$$ = $2;}
    ;

basicType : TINT { $$ = new NIdentifier("int"); }
    | TCHAR { $$ = new NIdentifier("char"); }
    | TDOUBLE { $$ = new NIdentifier("double"); }
    | TFLOAT { $$ = new NIdentifier("float"); }
    | TBOOLEAN { $$ = new NIdentifier("boolean"); }
    | TVOID { $$ = new NIdentifier("void"); }
    | TSTRING { $$ = new NIdentifier("string"); }
    ;

id : TID { $$ = new NIdentifier(*$1); };
%%

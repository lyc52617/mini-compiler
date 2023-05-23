D            [0-9]
L            [a-zA-Z_]
H            [a-fA-F0-9]
E            ([Ee][+-]?{D}+)

%{
#include <stdio.h>
#include <iostream>
#include <string>
#include "treenode.h"
#include "parsing.hpp"

#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)

int column = 0;

void count(void);
void comment(void);
%}

%option yylineno

%%
    /* match two types of comments */
"/*"            { comment();               }

"if"                    count();puts("TIF"); return TOKEN(TIF);
"else"                  count();puts("TELSE"); return TOKEN(TELSE);
"return"                count();puts("TRETURN"); return TOKEN(TRETURN);
"for"                   count();puts("TFOR"); return TOKEN(TFOR);
"while"                 count();puts("TWHILE"); return TOKEN(TWHILE);
"struct"                count();puts("TSTRUCT"); return TOKEN(TSTRUCT);
"int"                   count();SAVE_TOKEN; puts("TYINT");  return TYINT;
"double"                count();SAVE_TOKEN; puts("TYDOUBLE"); return TYDOUBLE;
"float"                 count();SAVE_TOKEN; puts("TYFLOAT"); return TYFLOAT;
"char"                  count();SAVE_TOKEN; puts("TYCHAR"); return TYCHAR;
"bool"                  count();SAVE_TOKEN; puts("TYBOOL"); return TYBOOL;
"string"                count();SAVE_TOKEN; puts("TYSTRING"); return TYSTRING;
"void"                  count();SAVE_TOKEN; puts("TYVOID"); return TYVOID;
"extern"                count();SAVE_TOKEN; puts("TEXTERN"); return TEXTERN;
[a-zA-Z_][a-zA-Z0-9_]*	count();SAVE_TOKEN; puts("TIDENTIFIER"); return TIDENTIFIER;
[0-9]+\.[0-9]*			count();SAVE_TOKEN; puts("TDOUBLE"); return TDOUBLE;
[0-9]+  				count();SAVE_TOKEN; puts("TINTEGER"); return TINTEGER;
\'.\'|\'\\.\'           count();SAVE_TOKEN; puts("TCHAR")； return TCHAR;
\"(\\.|[^"])*\"         count();SAVE_TOKEN; puts("TSTRING"); return TSTRING;
"="						count();puts("TEQUAL"); return TOKEN(TEQUAL);
"=="					count();puts("TCEQ"); return TOKEN(TCEQ);
"!="                    count();puts("TCNE"); return TOKEN(TCNE);
"<"                     count();puts("TCLT"); return TOKEN(TCLT);
"<="                    count();puts("TCLE"); return TOKEN(TCLE);
">"                     count();puts("TCGT"); return TOKEN(TCGT);
">="                    count();puts("TCGE"); return TOKEN(TCGE);
"("                     count();puts("TLPAREN"); return TOKEN(TLPAREN);
")"                     count();puts("TRPAREN"); return TOKEN(TRPAREN);
"{"                     count();puts("TLBRACE"); return TOKEN(TLBRACE);
"}"                     count();puts("TRBRACE"); return TOKEN(TRBRACE);
"["                     count();puts("TLBRACKET"); return TOKEN(TLBRACKET);
"]"                     count();puts("TRBRACKET"); return TOKEN(TRBRACKET);
"."                     count();puts("TDOT"); return TOKEN(TDOT);
","                     count();puts("TCOMMA"); return TOKEN(TCOMMA);
"+"                     count();puts("TPLUS"); return TOKEN(TPLUS);
"-"                     count();puts("TMINUS"); return TOKEN(TMINUS);
"*"                     count();puts("TMUL"); return TOKEN(TMUL);
"/"                     count();puts("TDIV"); return TOKEN(TDIV);
"&"                     count();puts("TAND"); return TOKEN(TAND);
"|"                     count();puts("TOR"); return TOKEN(TOR);
"^"                     count();puts("TXOR"); return TOKEN(TXOR);
"%"                     count();puts("TMOD"); return TOKEN(TMOD);
">>"                    count();puts("TSHIFTR"); return TOKEN(TSHIFTR);
"<<"                    count();puts("TSHIFTL"); return TOKEN(TSHIFTL);
";"                     count();puts("TSEMICOLON"); return TOKEN(TSEMICOLON);
.						count();printf("Unknown token:%s\n", yytext); yyterminate();

[ \t\v\n\f]     { count(); }
.               { printf("unknown token : %s in line: %d\n", yytext, yylineno); }

%%

int yywrap(void)
{
    return 1;
}


void comment(void)
{
    column = 0;
    char c, prev = 0;
    
    while (std::cin >> c)      /* (EOF maps to 0) */
    {
        if (c == '/' && prev == '*')
            return;
        prev = c;
    }
    printf("unterminated comment");
}

void count(void)
{
    int i;

    for (i = 0; yytext[i] != '\0'; i++)
        if (yytext[i] == '\n')
            column = 0;
        else if (yytext[i] == '\t')
            column += 4 - (column % 4);
        else
            column++;

    
}


%{
#include <stdio.h>
#include <iostream>
#include <string>
#include<vector>
#include "treenode.h"
#include "parsing.hpp"

#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)

int countline=0,countchar=0;

void count(void);
%}

%option noyywrap

%%
    /* match two types of comments */
"/*"[^*]*[*]+([^*/][^*]*[*]+)*"/"						{ puts("COMMENT"); }
"//".*													{ puts("COMMENT"); }

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
[0-9]+\.[0-9]*			count();SAVE_TOKEN; puts("FLOAT"); return TFLOAT;
[0-9]+  				count();SAVE_TOKEN; puts("TINTEGER"); return TINTEGER;
"true|false"            count();SAVE_TOKEN; puts("TBOOL"); return TBOOL;
\'.\'                   count();SAVE_TOKEN; puts("TCHAR")； return TCHAR;
|\'\\.\'                count();yylval.string = esacpe(yytext+1,yyleng-2); puts("TCHAR")； return TCHAR;
\"(\\.|[^"])*\"         count();yylval.string = esacpe(yytext+1,yyleng-2); puts("TSTRING"); return TSTRING;
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

[ \t\v\n\f\r]             { count(); }
.                       printf("Unknown token:%s\n", yytext); yyterminate();

%%



void count(void)
{
    for(auto ch: std::string(yytext, yyleng)) 
    {
        if(ch == '\n')
        {
            countchar=0;
            countline++;
        }
        else if(ch=='r')
        {
            countchar=0;
        }
        else
        countchar++;
    }
}

std::string *escape(char ch[], int length)
{
    std::vector<char> cVec;
    int i;
    char prev = '\0';
    for (i = 0; i < length; i++) {
        if (prev != '\\') {
            if (ch[i] != '\\') {
                cVec.push_back(ch[i]);
            } else {
                prev = '\\';
            }
        } else {
            switch (ch[i])
            {
            case 'n': cVec.push_back('\n'); prev = '\0'; break;
            case 't': cVec.push_back('\t'); prev = '\0'; break;
            case 'b': cVec.push_back('\b'); prev = '\0'; break;
            case '\'': cVec.push_back('\''); prev = '\0'; break;
            case '\"': cVec.push_back('\"'); prev = '\0'; break;
            case '0': cVec.push_back('\0'); prev = '\0'; break;
            case '\\': cVec.push_back('\\'); prev = '\0'; break;
            default: prev = '\0'; break;
            }
        }
    }
    return new std::string(cVec.begin(), cVec.end());
}
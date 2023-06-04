%{
#include <iostream>
#include <string>
#include <vector>
#include "ast.h"
#include "parser.hpp"

#define STRING_TOKEN    yylval.val = new std::string(yytext, yyleng)
#define TOKEN(t)        yylval.token = t

int currentchar = 0;
int currentline = 1;
std::string curToken;
void countchar();
void countline();
std::string* escapetochar(char ch[], int length);
%}

%option noyywrap

%%


[ \t]                   {countchar();}
\n|\r\n                 {countline();};
"++"                    {countchar(); TOKEN(TINC); return TINC;}
"--"                    {countchar(); TOKEN(TDEC); return TDEC;}
"("                     {countchar(); TOKEN(TLSB); return TLSB;}
")"                     {countchar(); TOKEN(TRSB); return TRSB;}
"["                     {countchar(); TOKEN(TLMB); return TLMB;}
"]"                     {countchar(); TOKEN(TRMB); return TRMB;}
"{"                     {countchar(); TOKEN(TLLB); return TLLB;}
"}"                     {countchar(); TOKEN(TRLB); return TRLB;}
"."                     {countchar(); TOKEN(TDOT); return TDOT;}
":"                     {countchar(); TOKEN(TCOLON); return TCOLON;}
";"                     {countchar(); TOKEN(TSEMI); return TSEMI;}
","                     {countchar(); TOKEN(TCOMMA); return TCOMMA;}
"+"                     {countchar(); TOKEN(TPLUS); return TPLUS;}
"-"                     {countchar(); TOKEN(TMINUS); return TMINUS;}
"//".*|[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]              {countchar(); for(auto ch: std::string(yytext, yyleng)) if(ch == '\n') countline(); }
true|false                {countchar(); STRING_TOKEN; return TBOOL;}
0|[1-9][0-9]*              {countchar(); STRING_TOKEN; return TINTEGER;}
[0-9]+(\.[0-9]+)f            {countchar(); STRING_TOKEN; return TFNUMBER;}
[0-9]+(\.[0-9]+)d?             {countchar(); STRING_TOKEN; return TDNUMBER;}
'.'|'\\.'               {countchar(); yylval.val = escapetochar(yytext + 1, yyleng - 2); return TCHARACTER;}
\".*\"                  {countchar(); yylval.val = escapetochar(yytext + 1, yyleng - 2); return TSTR;}
"*"                     {countchar(); TOKEN(TMUL); return TMUL;}
"/"                     {countchar(); TOKEN(TDIV); return TDIV;}
"%"                     {countchar(); TOKEN(TMOD); return TMOD;}
"^"                     {countchar(); TOKEN(TXOR); return TXOR;}
"&&"                    {countchar(); TOKEN(TAND); return TAND;}
"||"                    {countchar(); TOKEN(TOR); return TOR;}
">"                     {countchar(); TOKEN(TGT); return TGT;}
">="                    {countchar(); TOKEN(TGE); return TGE;}
"<"                     {countchar(); TOKEN(TLT); return TLT;}
"<="                    {countchar(); TOKEN(TLE); return TLE;}
"!="                    {countchar(); TOKEN(TNE); return TNE;}
"!"                     {countchar(); TOKEN(TNOT); return TNOT;}
"=="                    {countchar(); TOKEN(TEQ); return TEQ;}
"="                     {countchar(); TOKEN(TASSIGN); return TASSIGN;}

"if"                    {countchar(); TOKEN(TIF); return TIF;}
"else"                  {countchar(); TOKEN(TELSE); return TELSE;}
"while"                 {countchar(); TOKEN(TWHILE); return TWHILE;}
"for"                   {countchar(); TOKEN(TFOR); return TFOR;}
"do"                    {countchar(); TOKEN(TDO); return TDO;}
"break"                 {countchar(); TOKEN(TBREAK); return TBREAK;}
"continue"              {countchar(); TOKEN(TCONTINUE); return TCONTINUE;}
"switch"                {countchar(); TOKEN(TSWITCH); return TSWITCH;}
"case"                  {countchar(); TOKEN(TCASE); return TCASE;}
"default"               {countchar(); TOKEN(TDEFAULT); return TDEFAULT;}
"return"                {countchar(); TOKEN(TRETURN); return TRETURN;}

"int"                   {countchar(); TOKEN(TINT); return TINT;}
"char"                  {countchar(); TOKEN(TCHAR); return TCHAR;}
"double"                {countchar(); TOKEN(TDOUBLE); return TDOUBLE;}
"float"                 {countchar(); TOKEN(TFLOAT); return TFLOAT;}
"bool"               {countchar(); TOKEN(TBOOLEAN); return TBOOLEAN;}
"const"                 {countchar(); TOKEN(TCONST); return TCONST;}
"void"                  {countchar(); TOKEN(TVOID); return TVOID;}
"enum"                  {countchar(); TOKEN(TENUM); return TENUM;}
"string"                {countchar(); TOKEN(TSTRING); return TSTRING;}

"new"                   {countchar(); TOKEN(TNEW); return TNEW;}
"this"                  {countchar(); TOKEN(TTHIS); return TTHIS;}
"struct"                {countchar(); TOKEN(TSTRUCT); return TSTRUCT;}

[a-zA-Z_][0-9a-zA-Z_]*  {countchar(); STRING_TOKEN; return TID;}

.                       {countchar(); printf("Unknown token!\n"); yyterminate();}
%%


std::string *escapetochar(char ch[], int length)
{
    std::vector<char> vecchar;
    int i;
    char prev = '\0';
    for (i = 0; i < length; i++) {
         if (prev == '\\') {
            switch (ch[i])
            {
            case 'n': vecchar.push_back('\n'); prev = '\0'; break;
            case 't': vecchar.push_back('\t'); prev = '\0'; break;
            case 'b': vecchar.push_back('\b'); prev = '\0'; break;
            case '\'': vecchar.push_back('\''); prev = '\0'; break;
            case '\"': vecchar.push_back('\"'); prev = '\0'; break;
            case '0': vecchar.push_back('\0'); prev = '\0'; break;
            case '\\': vecchar.push_back('\\'); prev = '\0'; break;
            default: prev = '\0'; break;
            }
        }
        else {
            if (ch[i] != '\\') {
                vecchar.push_back(ch[i]);
            } else {
                prev = '\\';
            }
        }
    }
    return new std::string(vecchar.begin(), vecchar.end());
}

void countchar() {
    currentchar += yyleng;
    curToken = std::move(yytext);
}


void countline() {
    currentchar = 0;
    currentline++;
}
/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_HOME_LIU_COMPILER_PARSER_HPP_INCLUDED
# define YY_YY_HOME_LIU_COMPILER_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TLSB = 258,
    TRSB = 259,
    TLMB = 260,
    TRMB = 261,
    TLLB = 262,
    TRLB = 263,
    TDOT = 264,
    TCOLON = 265,
    TSEMI = 266,
    TPLUS = 267,
    TMINUS = 268,
    TMUL = 269,
    TDIV = 270,
    TMOD = 271,
    TXOR = 272,
    TAND = 273,
    TOR = 274,
    TQUOTE = 275,
    TSTRUCT = 276,
    TGT = 277,
    TGE = 278,
    TLT = 279,
    TLE = 280,
    TNE = 281,
    TEQ = 282,
    TASSIGN = 283,
    TNOT = 284,
    TCOMMA = 285,
    TINC = 286,
    TDEC = 287,
    TIF = 288,
    TELSE = 289,
    TWHILE = 290,
    TFOR = 291,
    TDO = 292,
    TBREAK = 293,
    TCONTINUE = 294,
    TSWITCH = 295,
    TCASE = 296,
    TDEFAULT = 297,
    TINT = 298,
    TCHAR = 299,
    TDOUBLE = 300,
    TFLOAT = 301,
    TBOOLEAN = 302,
    TCONST = 303,
    TVOID = 304,
    TENUM = 305,
    TSTRING = 306,
    TNEW = 307,
    TTHIS = 308,
    TRETURN = 309,
    TID = 310,
    TINTEGER = 311,
    TBOOL = 312,
    TDNUMBER = 313,
    TFNUMBER = 314,
    TCHARACTER = 315,
    TSTR = 316
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 20 "/home/liu/compiler/parser.y" /* yacc.c:1909  */

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

#line 132 "/home/liu/compiler/parser.hpp" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_HOME_LIU_COMPILER_PARSER_HPP_INCLUDED  */

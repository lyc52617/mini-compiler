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

#ifndef YY_YY_PARSER_HPP_INCLUDED
# define YY_YY_PARSER_HPP_INCLUDED
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
    TIDENTIFIER = 258,
    TINTEGER = 259,
    TDOUBLE = 260,
    TCHAR = 261,
    TSTRING = 262,
    TBOOL = 263,
    TFLOAT = 264,
    TYINT = 265,
    TYDOUBLE = 266,
    TYFLOAT = 267,
    TYCHAR = 268,
    TYBOOL = 269,
    TYVOID = 270,
    TYSTRING = 271,
    TEXTERN = 272,
    TLITERAL = 273,
    TCEQ = 274,
    TCNE = 275,
    TCLT = 276,
    TCLE = 277,
    TCGT = 278,
    TCGE = 279,
    TEQUAL = 280,
    TLPAREN = 281,
    TRPAREN = 282,
    TLBRACE = 283,
    TRBRACE = 284,
    TCOMMA = 285,
    TDOT = 286,
    TSEMICOLON = 287,
    TLBRACKET = 288,
    TRBRACKET = 289,
    TQUOTATION = 290,
    TPLUS = 291,
    TMINUS = 292,
    TMUL = 293,
    TDIV = 294,
    TAND = 295,
    TOR = 296,
    TMOD = 297,
    TNEG = 298,
    TNOT = 299,
    TSHIFTL = 300,
    TSHIFTR = 301,
    TIF = 302,
    TELSE = 303,
    TFOR = 304,
    TWHILE = 305,
    TRETURN = 306,
    TBREAK = 307,
    TSTRUCT = 308,
    TXOR = 309
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 17 "parser.y" /* yacc.c:1909  */

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

#line 123 "parser.hpp" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_HPP_INCLUDED  */

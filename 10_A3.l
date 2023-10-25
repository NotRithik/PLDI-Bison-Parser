%{

#include "10_A3.tab.h"

%}

TOKEN ({KEYWORD}|{IDENTIFIER}|{CONSTANT}|{STRING-LITERAL}|{PUNCTUATOR})

KEYWORD (char|else|for|if|int|return|void)

IDENTIFIER {IDENTIFIER-NONDIGIT}+({IDENTIFIER-NONDIGIT}|{DIGIT})*
IDENTIFIER-NONDIGIT [a-zA-Z_]
DIGIT [0-9]

CONSTANT ({INTEGER-CONSTANT}|{CHARACTER-CONSTANT})

INTEGER-CONSTANT ({NONZERO-DIGIT}{DIGIT}*)|((0)*{DIGIT}*)
NONZERO-DIGIT [1-9]
SIGN [+\-]

CHARACTER-CONSTANT \'{C-CHAR-SEQUENCE}\'
C-CHAR-SEQUENCE {C-CHAR}+
C-CHAR [^\'\\\n\r]|({ESCAPE-SEQUENCE})
ESCAPE-SEQUENCE (\\\')|(\\\")|(\\\?)|(\\\\)|(\\a)|(\\b)|(\\f)|(\\n)|(\\r)|(\\t)|(\\v)

STRING-LITERAL \"{S-CHAR-SEQUENCE}\"
S-CHAR-SEQUENCE {S-CHAR}*
S-CHAR [^\"\\\n\r]|({ESCAPE-SEQUENCE})

PUNCTUATOR (\[|\]|\(|\)|\{|\}|(->)|&|\*|\+|-|\/|%|!|\?|<|>|(<=)|(>=)|(==)|(!=)|(&&)|(\|\|)|=|:|;|,)

COMMENT ({MULTI-LINE-COMMENT}|{SINGLE-LINE-COMMENT})
MULTI-LINE-COMMENT (\/\*([^*]|\*[^/])*\*\/)
SINGLE-LINE-COMMENT (\/\/[^\n\r]*)

WS [ \n\t\r]

INVALID-TOKEN .

%%

{KEYWORD} {printf("<KEYWORD,%s>", yytext);}
{IDENTIFIER} {printf("<IDENTIFIER,%s>", yytext);}
{INTEGER-CONSTANT} {printf("<INTEGER-CONSTANT,%s>", yytext);}
{CHARACTER-CONSTANT} {printf("<CHARACTER-CONSTANT,%s>", yytext);}
{STRING-LITERAL} {printf("<STRING-LITERAL,%s>", yytext);}
{COMMENT} {;}
{PUNCTUATOR} {printf("<PUNCTUATOR,%s>", yytext);}
{WS} {;}
{INVALID-TOKEN}   {printf("<INVALID TOKEN,%s>", yytext);
                   yyterminate();}

%%

int yywrap(){
    return 1;
}
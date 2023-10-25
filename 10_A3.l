%{

#include "10_A3.tab.h"

%}

%option yylineno

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

{KEYWORD} {
    if (strcmp(yytext, "char") == 0)   return CHAR;
    if (strcmp(yytext, "else") == 0)   return ELSE;
    if (strcmp(yytext, "for") == 0)    return FOR;
    if (strcmp(yytext, "if") == 0)     return IF;
    if (strcmp(yytext, "int") == 0)    return INT;
    if (strcmp(yytext, "return") == 0) return RETURN;
    if (strcmp(yytext, "void") == 0)   return VOID;
    printf("<KEYWORD,%s>", yytext);
}

{IDENTIFIER} {
    yylval.str_val = strdup(yytext);
    printf("<IDENTIFIER,%s>", yytext);
    return IDENTIFIER;
}

{INTEGER-CONSTANT} {
    yylval.int_val = atoi(yytext);
    printf("<INTEGER-CONSTANT,%s>", yytext);
    return INTEGER_CONSTANT;
}

{CHARACTER-CONSTANT} {
    yylval.char_val = yytext[1]; // TODO: don't assume well formed input
    printf("<CHARACTER-CONSTANT,%s>", yytext);
    return CHARACTER_CONSTANT;
}

{STRING-LITERAL} {
    yylval.str_val = strdup(yytext);
    printf("<STRING-LITERAL,%s>", yytext);
    return STRING_LITERAL;
}

{COMMENT} {;}


{PUNCTUATOR} {
    switch(yytext[0]) {
        case '(': return OP_PARENTHESIS;
        case ')': return CL_PARENTHESIS;
        case '[': return OP_BRACKET;
        case ']': return CL_BRACKET;
        case '{': return OP_BRACE;
        case '}': return CL_BRACE;
        case ',': return COMMA;
        case ';': return SEMICOLON;
        case ':': return COLON;
        case '=': 
            if (yytext[1] == '=') return EQ;
            else return ASSIGN;
        case '+': return PLUS;
        case '-': 
            if (yytext[1] == '>') return ARROW;
            else return MINUS;
        case '*': return ASTERISK;
        case '/': return DIVIDE;
        case '&':
            if (yytext[1] == '&') return AND;
            else return AMPERSAND;
        case '%': return MODULO;
        case '!': 
            if (yytext[1] == '=') return NEQ;
            else return NOT;
        case '>': 
            if (yytext[1] == '=') return GEQ;
            else return GREATER_THAN;
        case '<': 
            if (yytext[1] == '=') return LEQ;
            else return LESS_THAN;
        case '|':
            if (yytext[1] == '|') return OR;
            break;
        case '?': return TERNARY_CONDITIONAL;
        default: 
            break;
            //TODO: check if it is possible for yytext[1] to be a bad memory location
    }
    printf("<PUNCTUATOR,%s>", yytext);
}

{WS} {;}

{INVALID-TOKEN} {
    printf("<INVALID TOKEN,%s>", yytext);
    yyterminate();
}

%%

int yywrap(){
    return 1;
}
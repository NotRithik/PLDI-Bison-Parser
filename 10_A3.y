%{
#include <stdio.h>

extern int yylex();
extern void yyerror(char *s);
%}

%token NUMBER
%token IDENTIFIER
%token CONSTANT
%token STRING_LITERAL
%token INTEGER_CONSTANT
%token CHAR_CONSTANT
%token OP_PARENTHESIS "("
%token CL_PARENTHESIS ")"
%token OP_BRACKET " ["
%token CL_BRACKET "]"
%token OP_BRACE "{"
%token CL_BRACE "}"
%token COMMA ","
%token SEMICOLON ";"
%token COLON ":"
%token ASSIGN "="
%token PLUS "+"
%token MINUS "-"
%token TIMES "*"
%token DIVIDE "/"
%token AMPERSAND "&"
%token MODULO "%"
%token INT "int"
%token CHAR "char"
%token VOID "void"
%token IF "if"
%token ELSE "else"
%token FOR "for"
%token RETURN "return"

%left '+' '-' '*' '/' 

%token ARROW "->"
%token AND "&&"
%token OR "||"
%token GEQ ">="
%token LEQ "<="
%token EQ "=="
%token NEQ "!="
%token LESS_THAN "<"
%token GREATER_THAN ">"
%token NOT "!"
%token TERNARY_CONDITIONAL "?"


%%

primary_expression: IDENTIFIER
    | CONSTANT
    | STRING_LITERAL
    | OP_PARENTHESIS expression CL_PARENTHESIS
    ;
postfix_expression: primary_expression
    | postfix_expression OP_BRACKET expression CL_BRACKET
    | postfix_expression OP_PARENTHESIS CL_PARENTHESIS
    | postfix_expression OP_PARENTHESIS argument_expression_list CL_PARENTHESIS
    | postfix_expression ARROW IDENTIFIER
    ;

argument_expression_list: assignment_expression
    | argument_expression_list COMMA assignment_expression
    ;

unary_expression: postfix_expression
    | unary_operator unary_expression
    ;

unary_operator: AMPERSAND
    | TIMES
    | ASSIGN
    | MINUS 
    | MODULO
    ;

multiplicative_expression: unary_expression
    | multiplicative_expression TIMES unary_expression
    | multiplicative_expression DIVIDE unary_expression
    | multiplicative_expression MODULO unary_expression
    ;
additive_expression: multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    ;
relation_expression: additive_expression
    | relation_expression LESS_THAN additive_expression
    | relation_expression GREATER_THAN additive_expression
    | relation_expression LEQ additive_expression
    | relation_expression GEQ additive_expression
    ;
equality_expression: relation_expression
    | equality_expression EQ relation_expression
    | equality_expression NEQ relation_expression
    ;
logical_AND_expression: equality_expression
    | logical_AND_expression AND equality_expression
    ;
logical_OR_expression: logical_AND_expression
    | logical_OR_expression OR logical_AND_expression
    ;

conditional_expression: logical_OR_expression
    | logical_OR_expression TERNARY_CONDITIONAL expression COLON conditional_expression
    ;
assignment_expression: conditional_expression
    | unary_expression ASSIGN assignment_expression
    ;

expression: assignment_expression
    | expression COMMA assignment_expression
    ;

declaration: type_specifier init_declarator SEMICOLON
    ;
init_declarator: declarator
    | declarator ASSIGN initializer
    ;
type_specifier: INT
    | CHAR
    | VOID
    ;
declarator: pointer direct_declarator
    | direct_declarator
    ;
direct_declarator: IDENTIFIER 
    | IDENTIFIER 
    | IDENTIFIER OP_BRACKET INTEGER_CONSTANT CL_BRACKET
    | IDENTIFIER OP_PARENTHESIS parameter_list CL_PARENTHESIS
    | IDENTIFIER OP_PARENTHESIS CL_PARENTHESIS
    ;
pointer : TIMES
    ;

parameter_list: parameter_declaration
    | parameter_list COMMA parameter_declaration
    ;
parameter_declaration: type_specifier pointer IDENTIFIER
    | type_specifier pointer
    | IDENTIFIER 
    ;
initializer : assignment_expression
    ;

statement: compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;
compound_statement: OP_BRACE CL_BRACE
    | OP_BRACE block_item_list CL_BRACE
    ;
block_item_list: block_item
    | block_item_list block_item
    ;
block_item: declaration
    | statement
    ;
expression_statement: expression SEMICOLON
    | SEMICOLON
    ;
selection_statement : IF OP_PARENTHESIS expression CL_PARENTHESIS statement
    | IF OP_PARENTHESIS expression CL_PARENTHESIS statement ELSE statement
    ;
iteration_statement:
    FOR OP_PARENTHESIS expressionopt SEMICOLON expressionopt SEMICOLON expressionopt CL_PARENTHESIS statement
    ;

expressionopt: expression
    | /* empty */
    ;

jump_statement: RETURN expressionopt SEMICOLON

translation_unit: functional_definition
    | declaration
    ;
functional_definition: type_specifier declarator compound_statement
    ;
%%
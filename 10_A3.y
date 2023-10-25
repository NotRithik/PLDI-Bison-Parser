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
%token ASTERISK "*"
%token DIVIDE "/"
%token AMPERSAND "&"
%token MODULO "%"
%token EXCLAMATION "!"
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

// Optionals

IDENTIFIER_opt: IDENTIFIER
    | /* empty */
    ;

argument_expression_list_opt: argument_expression_list
    | /* empty */
    ;

pointer_opt: pointer
    | /* empty */
    ;

parameter_list_opt: parameter_list
    | /* empty */
    ;

block_item_list_opt: block_item_list
    | /* empty */
    ;

expression_opt: expression
    | /* empty */
    ;

// Expressions
primary_expression: IDENTIFIER
    | CONSTANT
    | STRING_LITERAL
    | OP_PARENTHESIS expression CL_PARENTHESIS
    ;

postfix_expression: primary_expression
    | postfix_expression OP_BRACKET expression CL_BRACKET
    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS
    | postfix_expression ARROW IDENTIFIER
    ;

argument_expression_list: assignment_expression
    | argument_expression_list COMMA assignment_expression
    ;

unary_expression: postfix_expression
    | unary_operator unary_expression
    ;

unary_operator: AMPERSAND
    | ASTERISK
    | PLUS
    | MINUS
    | EXCLAMATION
    ;

multiplicative_expression: unary_expression
    | multiplicative_expression ASTERISK unary_expression
    | multiplicative_expression DIVIDE unary_expression
    | multiplicative_expression MODULO unary_expression
    ;

additive_expression: multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    ;

relational_expression: additive_expression
    | relational_expression LESS_THAN additive_expression
    | relational_expression GREATER_THAN additive_expression
    | relational_expression LEQ additive_expression
    | relational_expression GEQ additive_expression
    ;

equality_expression: relational_expression
    | equality_expression EQ relational_expression
    | equality_expression NEQ relational_expression
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
    ;

// Declarations
declaration: type_specifier init_declarator SEMICOLON
    ;

init_declarator: declarator
    | declarator ASSIGN initializer
    ;

type_specifier: VOID
    | CHAR
    | INT
    ;

declarator: pointer_opt direct_declarator
    ;

direct_declarator: IDENTIFIER
    | IDENTIFIER OP_BRACKET INTEGER_CONSTANT CL_BRACKET
    | IDENTIFIER OP_PARENTHESIS parameter_list_opt CL_PARENTHESIS
    ;

pointer: ASTERISK
    ;

parameter_list: parameter_declaration
    | parameter_list COMMA parameter_declaration
    ;

parameter_declaration: type_specifier pointer_opt IDENTIFIER_opt
    ;

initializer: assignment_expression
    ;

// Statements
statement: compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;

compound_statement: OP_BRACE block_item_list_opt CL_BRACE
    ;

block_item_list: block_item
    | block_item_list block_item
    ;

block_item: declaration
    | statement
    ;

expression_statement: expression_opt SEMICOLON
    ;

selection_statement : IF OP_PARENTHESIS expression CL_PARENTHESIS statement
    | IF OP_PARENTHESIS expression CL_PARENTHESIS statement ELSE statement
    ;

iteration_statement:
    FOR OP_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CL_PARENTHESIS statement
    ;

jump_statement: RETURN expression_opt SEMICOLON

// Translation unit
translation_unit: external_declaration
    | translation_unit external_declaration
    ;

external_declaration: declaration
    | function_definition
    ;

function_definition: type_specifier declarator compound_statement
    ;
%%

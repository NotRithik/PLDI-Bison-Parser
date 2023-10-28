%{
#include <stdio.h>

extern int yylex();
extern void yyerror(char *s);
%}

%union {
    int int_val;
    char char_val;
    char* str_val;
}

%token <str_val> IDENTIFIER
%token <str_val> STRING_LITERAL
%token <int_val> INTEGER_CONSTANT
%token <char_val> CHARACTER_CONSTANT
%token OP_PARENTHESIS "("
%token CL_PARENTHESIS ")"
%token OP_BRACKET "["
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
%token INT "int"
%token CHAR "char"
%token VOID "void"
%token IF "if"
%token ELSE "else"
%token FOR "for"
%token RETURN "return"

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

%left PLUS MINUS
%left ASTERISK DIVIDE MODULO
%left LESS_THAN GREATER_THAN LEQ GEQ
%left EQ NEQ
%left AND
%left OR
%right TERNARY_CONDITIONAL
%right ASSIGN
%nonassoc NOT AMPERSAND

%start translation_unit
%%

CONSTANT: INTEGER_CONSTANT
    | CHARACTER_CONSTANT
    ;

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
primary_expression: IDENTIFIER {printf("primary-expression\n");}
    | CONSTANT      {printf("primary-expression\n");}
    | STRING_LITERAL   {printf("primary-expression\n");}
    | OP_PARENTHESIS expression CL_PARENTHESIS {printf("primary-expression\n");}
    ;

postfix_expression: primary_expression {printf("postfix-expression\n");}
    | postfix_expression OP_BRACKET expression CL_BRACKET {printf("postfix-expression\n");}
    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {printf("postfix-expression\n");}
    | postfix_expression ARROW IDENTIFIER  {printf("postfix-expression\n");}
    ;

argument_expression_list: assignment_expression {printf("argument-expression-list\n");}
    | argument_expression_list COMMA assignment_expression {printf("argument-expression-list\n");}
    ;

unary_expression: postfix_expression {printf("unary-expression postfix-expression\n");}
    | unary_operator unary_expression {printf("unary-expression\n");}
    ;

unary_operator: AMPERSAND {printf("unary-operator\n");}
    | ASTERISK {printf("unary-operator\n");}
    | PLUS  {printf("unary-operator\n");}
    | MINUS {printf("unary-operator\n");}
    | NOT    {printf("unary-operator\n");}
    ;

multiplicative_expression: unary_expression {printf("multiplicative-expression\n");}
    | multiplicative_expression ASTERISK unary_expression {printf("multiplicative-expression\n");}
    | multiplicative_expression DIVIDE unary_expression {printf("multiplicative-expression\n");}
    | multiplicative_expression MODULO unary_expression {printf("multiplicative-expression\n");}
    ;

additive_expression: multiplicative_expression {printf("additive-expression\n");}
    | additive_expression PLUS multiplicative_expression {printf("additive-expression\n");}
    | additive_expression MINUS multiplicative_expression {printf("additive-expression\n");}
    ;

relational_expression: additive_expression {printf("relational-expression\n");}
    | relational_expression LESS_THAN additive_expression {printf("relational-expression\n");}
    | relational_expression GREATER_THAN additive_expression {printf("relational-expression\n");}
    | relational_expression LEQ additive_expression {printf("relational-expression\n");}
    | relational_expression GEQ additive_expression {printf("relational-expression\n");}
    ;

equality_expression: relational_expression  {printf("equality-expression\n");}
    | equality_expression EQ relational_expression {printf("equality-expression\n");}
    | equality_expression NEQ relational_expression {printf("equality-expression\n");}
    ;

logical_AND_expression: equality_expression  {printf("logical-AND-expression\n");}
    | logical_AND_expression AND equality_expression {printf("logical-AND-expression\n");}
    ;

logical_OR_expression: logical_AND_expression {printf("logical-OR-expression\n");}
    | logical_OR_expression OR logical_AND_expression {printf("logical-OR-expression\n");}
    ;

conditional_expression: logical_OR_expression {printf("conditional-expression\n");}
    | logical_OR_expression TERNARY_CONDITIONAL expression COLON conditional_expression {printf("conditional-expression\n");}
    ;

assignment_expression: conditional_expression {printf("assignment-expression\n");}
    | unary_expression ASSIGN assignment_expression {printf("assignment-expression\n");}
    ;

expression: assignment_expression  {printf("expression\n");}
    ;

// Declarations
declaration: type_specifier init_declarator SEMICOLON {printf("declaration\n");}
    ;

init_declarator: declarator {printf("init-declarator\n");}
    | declarator ASSIGN initializer {printf("init-declarator\n");}
    ;

type_specifier: VOID {printf("type-specifier\n");}
    | CHAR {printf("type-specifier\n");}
    | INT {printf("type-specifier\n");}
    ;

declarator: pointer_opt direct_declarator {printf("declarator\n");}
    ;

direct_declarator: IDENTIFIER {printf("direct-declarator\n");}
    | IDENTIFIER OP_BRACKET INTEGER_CONSTANT CL_BRACKET {printf("direct-declarator\n");}
    | IDENTIFIER OP_PARENTHESIS parameter_list_opt CL_PARENTHESIS {printf("direct-declarator\n");}
    ;

pointer: ASTERISK {printf("pointer\n");}
    ;

parameter_list: parameter_declaration {printf("parameter-list\n");}
    | parameter_list COMMA parameter_declaration {printf("parameter-list\n");}
    ;

parameter_declaration: type_specifier pointer_opt IDENTIFIER_opt {printf("parameter-declaration\n");}
    ;

initializer: assignment_expression {printf("initializer\n");}
    ;

// Statements
statement: compound_statement {printf("statement\n");}
    | expression_statement {printf("statement\n");} 
    | selection_statement  {printf("statement\n");}
    | iteration_statement {printf("statement\n");}
    | jump_statement {printf("statement\n");}
    ;

compound_statement: OP_BRACE block_item_list_opt CL_BRACE {printf("compound-statement\n");}
    ;

block_item_list: block_item {printf("block_item_list\n");}
    | block_item_list block_item  {printf("block_item_list\n");}
    ;

block_item: declaration {printf("block_item\n");}
    | statement  {printf("block_item\n");}
    ;

expression_statement: expression_opt SEMICOLON {printf("expression-statement\n");}
    ;

selection_statement: IF OP_PARENTHESIS expression CL_PARENTHESIS statement {printf("selection-statement\n");}
    | IF OP_PARENTHESIS expression CL_PARENTHESIS statement ELSE statement {printf("selection-statement\n");}
    ;

iteration_statement:  
    FOR OP_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CL_PARENTHESIS statement {printf("iteration-statement\n");}
    ;

jump_statement: RETURN expression_opt SEMICOLON {printf("jump-statement\n");}
    ;

// Translation unit
translation_unit: external_declaration {printf("translation-unit\n");}
    | translation_unit external_declaration {printf("translation-unit\n");}
    ;

external_declaration: declaration {printf("external-declaration\n");}
    | function_definition {printf("external-declaration\n");}
    ;

function_definition: type_specifier declarator compound_statement {printf("function-definition\n");}
    ;
%%

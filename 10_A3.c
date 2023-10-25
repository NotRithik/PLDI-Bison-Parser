extern int yylex();
extern int yyparse();

extern int yylineno;
extern char* yytext;

#include<stdio.h>

int main()
{
	yyparse();
	return 0;
}

void yyerror(char *s) {
	printf("Error: %s on '%s' at line %d, char\n",s, yytext, yylineno);
}
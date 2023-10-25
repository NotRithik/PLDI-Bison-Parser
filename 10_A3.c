extern int yylex();
extern int yyparse();

extern char* yytext;

#include<stdio.h>

int main()
{
	yyparse();
	return 0;
}

void yyerror(char *s) {
	printf("Error: %s on '%s'\n",s, yytext);
}
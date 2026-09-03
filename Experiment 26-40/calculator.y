%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(char *s);
%}

%token NUMBER

%left '+'
%left '*'

%%

expr:
      expr '+' expr
        { $$ = $1 + $3; }
    | expr '*' expr
        { $$ = $1 * $3; }
    | NUMBER
        { $$ = $1; }
    ;

%%

int main()
{
    printf("Enter arithmetic expression: ");
    yyparse();
    return 0;
}

int yyerror(char *s)
{
    printf("Invalid expression\n");
    return 0;
}

int yylex()
{
    int c;

    while ((c = getchar()) == ' ' || c == '\t');

    if (c >= '0' && c <= '9')
    {
        yylval = c - '0';
        return NUMBER;
    }

    if (c == '+' || c == '*')
        return c;

    if (c == '\n' || c == EOF)
        return 0;

    return c;
}
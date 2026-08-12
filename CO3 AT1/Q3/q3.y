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

input:
      expr
      {
          printf("\nFinal Result = %d\n", $1);
      }
      ;

expr:
      expr '+' term
      {
          $$ = $1 + $3;
          printf("E -> E + T     $$ = %d + %d = %d\n", $1, $3, $$);
      }
    | term
      {
          $$ = $1;
          printf("E -> T         $$ = %d\n", $$);
      }
    ;

term:
      term '*' factor
      {
          $$ = $1 * $3;
          printf("T -> T * F     $$ = %d * %d = %d\n", $1, $3, $$);
      }
    | factor
      {
          $$ = $1;
          printf("T -> F         $$ = %d\n", $$);
      }
    ;

factor:
      NUMBER
      {
          $$ = $1;
          printf("F -> NUMBER    $$ = %d\n", $$);
      }
      ;

%%

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

int yyerror(char *s)
{
    printf("Invalid expression\n");
    return 0;
}

int main()
{
    printf("Enter expression: ");
    yyparse();

    return 0;
}
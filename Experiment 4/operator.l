%{
#include<stdio.h>
%}

%%

"+"     { printf("+ is an Addition Operator\n"); }

"-"     { printf("- is a Subtraction Operator\n"); }

"*"     { printf("* is a Multiplication Operator\n"); }

"/"     { printf("/ is a Division Operator\n"); }

[ \t\n]+    ;

.       { printf("%s is NOT an Arithmetic Operator\n",yytext); }

%%

int main()
{
    printf("Enter Operators:\n");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
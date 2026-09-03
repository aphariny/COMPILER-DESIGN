%{
#include<stdio.h>
%}

%%

[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}   { printf("Valid Email Address\n"); }

.*                                                  { printf("Invalid Email Address\n"); }

%%

int yywrap()
{
    return 1;
}

int main()
{
    printf("Enter an email address: ");
    yylex();
    return 0;
}
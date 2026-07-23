%{
#include<stdio.h>
%}

%%

[a-zA-Z_][a-zA-Z0-9_]*      { printf("%s is a Valid Identifier\n",yytext); }

[0-9][a-zA-Z0-9_]*          { printf("%s is an Invalid Identifier\n",yytext); }

.                           { printf("%s is an Invalid Identifier\n",yytext); }

%%

int main()
{
    printf("Enter Identifier:\n");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
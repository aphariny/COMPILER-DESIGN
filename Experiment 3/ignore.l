%{
#include<stdio.h>
%}

%%

"//".*      { printf("\n[COMMENT SKIPPED]\n"); }

[ \t\n]+    ;

.           { putchar(yytext[0]); }

%%

int main()
{
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
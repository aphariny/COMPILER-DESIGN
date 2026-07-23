%{
#include<stdio.h>
#include<string.h>
%}

%%

.*    {
        if(strncmp(yytext,"//",2)==0)
            printf("Single Line Comment\n");

        else if(strncmp(yytext,"/*",2)==0 &&
                yytext[strlen(yytext)-2]=='*' &&
                yytext[strlen(yytext)-1]=='/')
            printf("Multi Line Comment\n");

        else
            printf("Not a Comment\n");
      }

%%

int main()
{
    printf("Enter input:\n");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
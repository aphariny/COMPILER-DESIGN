%{
#include<stdio.h>
%}

%%

[ \t\n]+      ;

"//".*        ;

[0-9]+        { printf("%s --> Constant\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*   { printf("%s --> Identifier\n", yytext); }


">="          { printf("%s --> Operator\n", yytext); }
"<="          { printf("%s --> Operator\n", yytext); }
"=="          { printf("%s --> Operator\n", yytext); }
"!="          { printf("%s --> Operator\n", yytext); }


"+"           { printf("%s --> Operator\n", yytext); }
"-"           { printf("%s --> Operator\n", yytext); }
"*"           { printf("%s --> Operator\n", yytext); }
"/"           { printf("%s --> Operator\n", yytext); }
"="           { printf("%s --> Operator\n", yytext); }
">"           { printf("%s --> Operator\n", yytext); }
"<"           { printf("%s --> Operator\n", yytext); }
";"           { printf("%s --> Operator\n", yytext); }
.             ;

%%

int main()
{
    printf("Enter C code:\n");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
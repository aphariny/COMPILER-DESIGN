%{
#include <stdio.h>
%}

%option noyywrap

%%

[0-9]+"."[0-9]+            { printf("Constant found: %s\n", yytext); }
[0-9]+                     { printf("Constant found: %s\n", yytext); }
\"([^\\\"]|\\.)*\"         { printf("Constant found: %s\n", yytext); }
\'([^\\\']|\\.)\'          { printf("Constant found: %s\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*     ; /* Ignore variable names and keywords */
.|\n                       ; /* Ignore other symbols and whitespaces */

%%

int main() {
    yyin = fopen("sample.c", "r");
    if (!yyin) {
        printf("Error: Cannot open sample.c\n");
        return 1;
    }

    printf("=== Extracted Constants ===\n");
    yylex();
    fclose(yyin);

    return 0;
}
%{
#include <stdio.h>
int line_no = 1;
%}

%option noyywrap

%%

^.*  { printf("%d: %s", line_no++, yytext); }
\n   { ECHO; }

%%

int main() {
    yyin = fopen("sample23.c", "r");
    if (!yyin) {
        printf("Error: Cannot open sample23.c\n");
        return 1;
    }

    printf("=== Program with Line Numbers ===\n\n");
    yylex();
    fclose(yyin);

    return 0;
}
%{
#include <stdio.h>
%}

%option noyywrap

%%

"<"[^>]+">"    { printf("HTML Tag: %s\n", yytext); }
.|\n           ; /* Ignore text content and newlines */

%%

int main() {
    yyin = fopen("sample.html", "r");
    if (!yyin) {
        printf("Error: Cannot open sample.html\n");
        return 1;
    }

    printf("=== HTML Tags Found ===\n");
    yylex();
    fclose(yyin);

    return 0;
}
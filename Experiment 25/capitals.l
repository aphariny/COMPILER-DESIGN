%{
#include <stdio.h>
%}

%option noyywrap

%%

[A-Z]+          { printf("Capital Word Found: %s\n", yytext); }
[a-zA-Z0-9]+    ; /* Ignore lowercase or mixed words */
.|\n            ; /* Ignore spaces and punctuation */

%%

int main() {
    printf("Enter text (Press Enter then Ctrl+Z on Windows to finish):\n");
    yylex();
    return 0;
}
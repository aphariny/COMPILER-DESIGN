%{
#include <stdio.h>
int pos_count = 0, neg_count = 0;
%}

%option noyywrap

%%

-[0-9]+(\.[0-9]+)?    { neg_count++; printf("Negative Number: %s\n", yytext); }
\+?[0-9]+(\.[0-9]+)?  { pos_count++; printf("Positive Number: %s\n", yytext); }
[ \t\n]+              ; /* Ignore spaces and newlines */
.                     ; /* Ignore other characters */

%%

int main() {
    printf("Enter numbers (Press Enter then Ctrl+Z on Windows to finish):\n\n");
    yylex();

    printf("\n=== Summary ===\n");
    printf("Total Positive Numbers: %d\n", pos_count);
    printf("Total Negative Numbers: %d\n", neg_count);

    return 0;
}
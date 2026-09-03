%{
#include <stdio.h>
#include <string.h>

char target[100];
int count = 0;
%}

%option noyywrap

%%

[a-zA-Z0-9_]+   {
    if (strcmp(yytext, target) == 0) {
        count++;
    }
}
.|\n            ; /* Ignore spaces, punctuation, and newlines */

%%

int main() {
    printf("Enter the word to search: ");
    scanf("%s", target);

    printf("Enter the sentence (Press Enter, then Ctrl+Z on Windows to finish):\n");
    yylex();

    printf("\nFrequency of word '%s' = %d\n", target, count);
    return 0;
}

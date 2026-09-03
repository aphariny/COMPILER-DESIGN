%{
#include <stdio.h>
int consonants = 0;
%}

%option noyywrap

%%

[aeiouAEIOU]       ; /* Ignore vowels */
[a-zA-Z]           { consonants++; } /* Count only consonant letters */
.|\n               ; /* Ignore whitespace, numbers, and punctuation */

%%

int main() {
    printf("Enter a sentence: ");
    yylex();

    printf("\nTotal Consonants = %d\n", consonants);
    return 0;
}
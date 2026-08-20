%{
#include <stdio.h>
int vowels = 0, consonants = 0;
%}

%option noyywrap

%%

[aeiouAEIOU]       { vowels++; }
[a-zA-Z]           { consonants++; }
.|\n               ; /* Ignore spaces, numbers, and punctuation */

%%

int main() {
    printf("Enter a sentence (Press Ctrl+Z or Ctrl+D to stop): \n");
    yylex();
    
    printf("\n=== Results ===\n");
    printf("Total Vowels     : %d\n", vowels);
    printf("Total Consonants : %d\n", consonants);
    
    return 0;
}
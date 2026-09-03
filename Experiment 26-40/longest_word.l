%{
#include <stdio.h>
#include <string.h>

int max_len = 0;
char longest[100] = "";
%}

%option noyywrap

%%

[a-zA-Z0-9]+   {
    int len = yyleng;
    if (len > max_len) {
        max_len = len;
        strcpy(longest, yytext);
    }
}
.|\n           ; /* Ignore punctuation, spaces, and newlines */

%%

int main() {
    printf("Enter sentence/text (Press Enter then Ctrl+Z on Windows to finish):\n\n");
    yylex();

    if (max_len > 0) {
        printf("\nLongest Word: %s\n", longest);
        printf("Length of Longest Word: %d\n", max_len);
    } else {
        printf("\nNo words entered.\n");
    }

    return 0;
}

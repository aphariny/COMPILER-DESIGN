%{
#include <stdio.h>
#include <string.h>

int max_len = 0;
char longest[100];
%}

%%
[a-zA-Z]+   {
                if (yyleng > max_len) {
                    max_len = yyleng;
                    strcpy(longest, yytext);
                }
            }
[ \t\n]+    { /* Ignore whitespace */ }
.           { /* Ignore punctuation/symbols */ }
%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter input text (Press Ctrl+D to finish):\n");
    yylex();
    printf("\nLongest Word: %s\n", longest);
    printf("Length: %d\n", max_len);
    return 0;
}
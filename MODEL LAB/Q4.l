%{
#include <stdio.h>

int alpha_count = 0;
int digit_count = 0;
%}

%%
[a-zA-Z]    { alpha_count++; }
[0-9]       { digit_count++; }
.|\n        { /* Ignore other characters and newlines */ }
%%

int yywrap() {
    return 1;
}

int main() {
    FILE *file = fopen("input.txt", "r");
    if (!file) {
        printf("Error: Could not open input.txt\n");
        return 1;
    }
    
    yyin = file;
    yylex();
    fclose(file);

    printf("Total Alphabetic Characters: %d\n", alpha_count);
    printf("Total Digits: %d\n", digit_count);

    return 0;
}
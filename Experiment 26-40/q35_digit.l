%{
#include <stdio.h>
int flag = 0;
%}

%option noyywrap

%%

^[0-9]$      { flag = 1; }
.|\n         ;

%%

int main() {
    printf("Enter a single character/input: ");
    yylex();

    if (flag == 1) {
        printf("\nThe given input is a DIGIT.\n");
    } else {
        printf("\nThe given input is NOT a digit.\n");
    }

    return 0;
}

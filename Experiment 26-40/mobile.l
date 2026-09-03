%{
#include <stdio.h>
int flag = 0;
%}

%option noyywrap

%%

^[6-9][0-9]{9}$    { flag = 1; }
.|\n               ;

%%

int main() {
    printf("Enter 10-digit mobile number: ");
    yylex();

    if (flag == 1) {
        printf("\nValid Mobile Number\n");
    } else {
        printf("\nInvalid Mobile Number\n");
    }

    return 0;
}
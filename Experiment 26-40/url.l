%{
#include <stdio.h>
int flag = 0;
%}

%option noyywrap

%%

^(https?|ftp):\/\/[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(:[0-9]+)?(\/[^\t\n\r ]*)?$   { flag = 1; }
^www\.[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(:[0-9]+)?(\/[^\t\n\r ]*)?$              { flag = 1; }
.|\n                                                                        ;

%%

int main() {
    printf("Enter URL: ");
    yylex();

    if (flag == 1) {
        printf("\nValid URL\n");
    } else {
        printf("\nInvalid URL\n");
    }

    return 0;
}
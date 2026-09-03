%{
#include <stdio.h>
#include <stdlib.h>

int is_valid = 0;

void check_date(char *str, char sep) {
    int d, m, y;
    if (sep == '/')
        sscanf(str, "%d/%d/%d", &d, &m, &y);
    else
        sscanf(str, "%d-%d-%d", &d, &m, &y);

    /* Year range check (reasonable student DOB: 1900 to 2026) */
    if (y < 1900 || y > 2026 || m < 1 || m > 12 || d < 1 || d > 31) {
        is_valid = 0;
        return;
    }

    /* Months with 30 days */
    if ((m == 4 || m == 6 || m == 9 || m == 11) && d > 30) {
        is_valid = 0;
        return;
    }

    /* February & Leap Year check */
    if (m == 2) {
        int is_leap = (y % 400 == 0) || (y % 4 == 0 && y % 100 != 0);
        if (d > (is_leap ? 29 : 28)) {
            is_valid = 0;
            return;
        }
    }

    is_valid = 1;
}
%}

%option noyywrap

%%

[0-9]{2}\/[0-9]{2}\/[0-9]{4}    { check_date(yytext, '/'); }
[0-9]{2}-[0-9]{2}-[0-9]{4}      { check_date(yytext, '-'); }
.|\n                            ;

%%

int main() {
    printf("Enter Date of Birth (DD/MM/YYYY or DD-MM-YYYY): ");
    yylex();

    if (is_valid) {
        printf("\nValid Date of Birth\n");
    } else {
        printf("\nInvalid Date of Birth\n");
    }

    return 0;
}
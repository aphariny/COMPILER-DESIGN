%{
#include <stdio.h>
#include <string.h>

char find_word[50] = "C";
char replace_word[50] = "Python";
%}

%option noyywrap

%%

[a-zA-Z0-9_]+   {
    if (strcmp(yytext, find_word) == 0) {
        fprintf(yyout, "%s", replace_word);
    } else {
        fprintf(yyout, "%s", yytext);
    }
}

.|\n            { fprintf(yyout, "%s", yytext); }

%%

int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");

    if (!yyin || !yyout) {
        printf("Error: Cannot open files!\n");
        return 1;
    }

    yylex();

    printf("Word replacement completed successfully.\n");
    printf("Check output.txt for the modified text.\n");

    fclose(yyin);
    fclose(yyout);

    return 0;
}

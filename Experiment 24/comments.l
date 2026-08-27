%{
#include <stdio.h>
int count = 0;
%}

%x COMMENT
%option noyywrap

%%

"//".*              { count++; }
"/*"                { count++; BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT>\n         ;
<COMMENT>.          ;

.|\n                { fprintf(yyout, "%s", yytext); }

%%

int main() {
    yyin = fopen("input.c", "r");
    yyout = fopen("output.c", "w");

    if (!yyin || !yyout) {
        printf("Error: Could not open file!\n");
        return 1;
    }

    yylex();

    printf("Total comment blocks/lines eliminated: %d\n", count);
    printf("Cleaned code successfully written to output.c\n");

    fclose(yyin);
    fclose(yyout);
    return 0;
}
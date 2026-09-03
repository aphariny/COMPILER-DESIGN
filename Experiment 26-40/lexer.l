%{
#include <stdio.h>
%}

%option noyywrap

%%

"#include"[ ]*<[^>]+>                       { printf("PREPROCESSOR DIRECTIVE : %s\n", yytext); }
"int"|"void"|"main"|"printf"|"return"       { printf("KEYWORD                : %s\n", yytext); }
[0-9]+                                      { printf("CONSTANT (INTEGER)     : %s\n", yytext); }
\"([^\\\"]|\\.)*\"                          { printf("CONSTANT (STRING)      : %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*                      { printf("IDENTIFIER             : %s\n", yytext); }
"="                                         { printf("ASSIGNMENT OPERATOR    : %s\n", yytext); }
[{}();,]                                    { printf("SEPARATOR / PUNCTUATOR : %s\n", yytext); }
[ \t\n]+                                    ; /* Ignore whitespaces and newlines */
.                                           { printf("SPECIAL CHARACTER      : %s\n", yytext); }

%%

int main() {
    yyin = fopen("sample.c", "r");
    if (!yyin) {
        printf("Error: Cannot open sample.c\n");
        return 1;
    }

    printf("=== TOKEN SEPARATION & IDENTIFICATION ===\n\n");
    yylex();
    fclose(yyin);

    return 0;
}
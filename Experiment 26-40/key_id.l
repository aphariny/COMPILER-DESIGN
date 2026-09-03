%{
#include <stdio.h>
%}

%option noyywrap

%%

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
    printf("KEYWORD    : %s\n", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("IDENTIFIER : %s\n", yytext);
}

[ \t\n]+    ; /* Ignore whitespaces, tabs, and newlines */
.           ; /* Ignore other characters like operators, numbers, punctuation */

%%

int main() {
    printf("Enter code/statement (Press Enter then Ctrl+Z on Windows to stop):\n\n");
    yylex();
    return 0;
}
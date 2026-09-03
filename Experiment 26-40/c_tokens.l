%{
#include <stdio.h>
%}

%option noyywrap

%%

"#include"[ ]*<[^>]+>|"#include"[ ]*\"[^\"]+\"   { printf("PREPROCESSOR DIRECTIVE : %s\n", yytext); }
"#define"[ ]+[a-zA-Z_][a-zA-Z0-9_]*             { printf("MACRO DEFINITION       : %s\n", yytext); }

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
    printf("KEYWORD                : %s\n", yytext);
}

\"([^\\\"]|\\.)*\"                              { printf("STRING LITERAL         : %s\n", yytext); }
\'([^\\\']|\\.)\'                               { printf("CHARACTER LITERAL      : %s\n", yytext); }

[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?                { printf("FLOATING CONSTANT      : %s\n", yytext); }
[0-9]+                                          { printf("INTEGER CONSTANT       : %s\n", yytext); }

"=="|"<="|">="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"%"|"="|"<"|">"|"!"|"&"|"|"|"^" {
    printf("OPERATOR               : %s\n", yytext);
}

[{}();,\[\]]                                    { printf("PUNCTUATOR / SEPARATOR : %s\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*                          { printf("IDENTIFIER             : %s\n", yytext); }

[ \t\n]+                                        ; /* Skip whitespace and newlines */
.                                               { printf("UNKNOWN TOKEN          : %s\n", yytext); }

%%

int main() {
    yyin = fopen("input.c", "r");
    if (!yyin) {
        printf("Error: Could not open input.c\n");
        return 1;
    }

    printf("================ TOKEN SEPARATION ================\n\n");
    yylex();
    printf("\n==================================================\n");

    fclose(yyin);
    return 0;
}

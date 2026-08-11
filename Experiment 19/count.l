%{
#include <stdio.h>

int characters = 0;
int words = 0;
int lines = 0;
%}

%x COMMENT

%%

"//".*                  ;
"/*"                    { BEGIN(COMMENT); }

<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { lines++; }
<COMMENT>.              ;

[ \t]+                  ;
\n                      { lines++; }

[a-zA-Z_][a-zA-Z0-9_]*  { words++; characters += yyleng; }
[0-9]+                  { characters += yyleng; }

.                       { characters++; }

%%

int main()
{
    yyin = fopen("sample.c", "r");

    if (yyin == NULL)
    {
        printf("File not found!\n");
        return 1;
    }

    yylex();

    fclose(yyin);

    printf("===== Lexical Analyzer =====\n\n");
    printf("Number of Characters = %d\n", characters);
    printf("Number of Words      = %d\n", words);
    printf("Number of Lines      = %d\n", lines);

    return 0;
}
int yywrap()
{
    return 1;
}
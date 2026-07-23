%{
#include<stdio.h>

int spaces=0;
int lines=0;
%}

%%

" "         { spaces++; }

\n          { lines++; }

.           ;

%%

int main()
{
    printf("Enter Text:\n");
    yylex();

    printf("\nNumber of White Spaces = %d\n",spaces);
    printf("Number of New Lines = %d\n",lines);

    return 0;
}

int yywrap()
{
    return 1;
}
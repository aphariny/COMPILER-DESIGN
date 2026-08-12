%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

typedef struct
{
    char name[30];
    char type[10];
} Symbol;

Symbol symbolTable[MAX];
int symbolCount = 0;

void addSymbol(char *name, char *type)
{
    strcpy(symbolTable[symbolCount].name, name);
    strcpy(symbolTable[symbolCount].type, type);
    symbolCount++;

    printf("Declared: %-15s Type = %s\n", name, type);
}

char* getType(char *name)
{
    int i;

    for (i = 0; i < symbolCount; i++)
    {
        if (strcmp(symbolTable[i].name, name) == 0)
            return symbolTable[i].type;
    }

    return NULL;
}

void assignVariable(char *left, char *right)
{
    char *leftType;
    char *rightType;

    leftType = getType(left);
    rightType = getType(right);

    printf("\nAssignment: %s = %s\n", left, right);

    if (leftType == NULL || rightType == NULL)
    {
        printf("Error: Undeclared variable\n");
        return;
    }

    printf("Left variable type  : %s\n", leftType);
    printf("Right variable type : %s\n", rightType);

    if (strcmp(leftType, rightType) == 0)
    {
        printf("No type conversion required.\n");
    }
    else if (strcmp(leftType, "float") == 0 &&
             strcmp(rightType, "int") == 0)
    {
        printf("Implicit conversion : int -> float\n");
        printf("Assignment allowed.\n");
    }
    else
    {
        printf("Incompatible assignment.\n");
    }

    printf("Final type of %s : %s\n", left, leftType);
}

int yylex();
int yyerror(char *s);
%}

%union
{
    char *str;
}

%token FLOAT
%token INT
%token <str> NAME

%%

program:
      statements
      ;

statements:
      statements statement
    | statement
    ;

statement:
      FLOAT NAME ';'
      {
          addSymbol($2, "float");
      }

    | INT NAME ';'
      {
          addSymbol($2, "int");
      }

    | NAME '=' NAME ';'
      {
          assignVariable($1, $3);
      }
    ;

%%

int yylex()
{
    int c;
    char buffer[30];
    int i;

    while ((c = getchar()) == ' ' ||
           c == '\t' ||
           c == '\n');

    if (c == EOF)
        return 0;

    if ((c >= 'a' && c <= 'z') ||
        (c >= 'A' && c <= 'Z') ||
        c == '_')
    {
        i = 0;

        while ((c >= 'a' && c <= 'z') ||
               (c >= 'A' && c <= 'Z') ||
               (c >= '0' && c <= '9') ||
               c == '_')
        {
            if (i < 29)
                buffer[i++] = c;

            c = getchar();
        }

        buffer[i] = '\0';

        if (c != EOF)
            ungetc(c, stdin);

        if (strcmp(buffer, "float") == 0)
            return FLOAT;

        if (strcmp(buffer, "int") == 0)
            return INT;

        yylval.str = (char*)malloc(strlen(buffer) + 1);
        strcpy(yylval.str, buffer);

        return NAME;
    }

    return c;
}

int yyerror(char *s)
{
    printf("Syntax error\n");
    return 0;
}

int main()
{
    printf("Enter declarations and assignments:\n");

    yyparse();

    return 0;
}
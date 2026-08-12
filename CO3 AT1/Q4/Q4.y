%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

typedef struct
{
    char name[30];
    char baseType[30];
} TypeEntry;

typedef struct
{
    char name[30];
    char type[30];
} VarEntry;

TypeEntry typeTable[MAX];
VarEntry varTable[MAX];

int typeCount = 0;
int varCount = 0;

char* copyString(const char *s)
{
    char *p = (char*)malloc(strlen(s) + 1);
    strcpy(p, s);
    return p;
}

void addType(char *name, char *baseType)
{
    strcpy(typeTable[typeCount].name, name);
    strcpy(typeTable[typeCount].baseType, baseType);
    typeCount++;

    printf("Type declared: %s = %s\n", name, baseType);
}

void addVariable(char *type, char *name)
{
    strcpy(varTable[varCount].name, name);
    strcpy(varTable[varCount].type, type);
    varCount++;

    printf("Variable declared: %s %s\n", type, name);
}

char* getVariableType(char *name)
{
    int i;

    for (i = 0; i < varCount; i++)
    {
        if (strcmp(varTable[i].name, name) == 0)
            return varTable[i].type;
    }

    return NULL;
}

char* getBaseType(char *type)
{
    int i;

    if (strcmp(type, "int") == 0)
        return "int";

    for (i = 0; i < typeCount; i++)
    {
        if (strcmp(typeTable[i].name, type) == 0)
            return getBaseType(typeTable[i].baseType);
    }

    return type;
}

void checkCompatibility(char *left, char *right)
{
    char *leftBase;
    char *rightBase;

    printf("\nChecking assignment: %s = %s\n", left, right);

    /* Name equivalence */
    if (strcmp(left, right) == 0)
        printf("Name Equivalence   : EQUIVALENT\n");
    else
        printf("Name Equivalence   : NOT EQUIVALENT\n");

    /* Structural equivalence */
    leftBase = getBaseType(left);
    rightBase = getBaseType(right);

    if (strcmp(leftBase, rightBase) == 0)
        printf("Structural Equivalence : EQUIVALENT\n");
    else
        printf("Structural Equivalence : NOT EQUIVALENT\n");
}

int yylex();
int yyerror(char *s);
%}

%union
{
    char *str;
}

%token TYPE
%token INT
%token <str> NAME

%type <str> type_spec

%%

program:
      statements
      ;

statements:
      statements statement
    | statement
    ;

statement:
      TYPE NAME '=' type_spec ';'
      {
          addType($2, $4);
      }

    | type_spec NAME ';'
      {
          addVariable($1, $2);
      }

    | NAME '=' NAME ';'
      {
          char *leftType;
          char *rightType;

          leftType = getVariableType($1);
          rightType = getVariableType($3);

          if (leftType == NULL || rightType == NULL)
          {
              printf("\nUndefined variable in assignment.\n");
          }
          else
          {
              checkCompatibility(leftType, rightType);
          }
      }
      ;

type_spec:
      INT
      {
          $$ = copyString("int");
      }

    | NAME
      {
          $$ = copyString($1);
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
        (c >= 'A' && c <= 'Z'))
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

        if (strcmp(buffer, "type") == 0)
            return TYPE;

        if (strcmp(buffer, "int") == 0)
            return INT;

        yylval.str = copyString(buffer);
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
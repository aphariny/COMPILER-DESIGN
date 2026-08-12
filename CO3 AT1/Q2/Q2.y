%{
#include <stdio.h>
#include <stdlib.h>

typedef struct Node
{
    char data;
    struct Node *left;
    struct Node *right;
} Node;

Node *root;

Node* createNode(char data, Node *left, Node *right)
{
    Node *newNode = (Node*)malloc(sizeof(Node));

    newNode->data = data;
    newNode->left = left;
    newNode->right = right;

    return newNode;
}

void preorder(Node *root)
{
    if (root != NULL)
    {
        printf("%c ", root->data);
        preorder(root->left);
        preorder(root->right);
    }
}

void inorder(Node *root)
{
    if (root != NULL)
    {
        inorder(root->left);
        printf("%c ", root->data);
        inorder(root->right);
    }
}

void postorder(Node *root)
{
    if (root != NULL)
    {
        postorder(root->left);
        postorder(root->right);
        printf("%c ", root->data);
    }
}

int yylex();
int yyerror(char *s);
%}

%union
{
    char ch;
    Node *node;
}

%token <ch> ID
%type <node> expr

%left '+'
%left '*'

%%

input:
    expr
    {
        root = $1;
    }
    ;

expr:
      expr '+' expr
      {
          $$ = createNode('+', $1, $3);
      }
    | expr '*' expr
      {
          $$ = createNode('*', $1, $3);
      }
    | ID
      {
          $$ = createNode($1, NULL, NULL);
      }
    ;

%%

int yylex()
{
    int c;

    while ((c = getchar()) == ' ' || c == '\t');

    if ((c >= 'a' && c <= 'z') ||
        (c >= 'A' && c <= 'Z'))
    {
        yylval.ch = c;
        return ID;
    }

    if (c == '+' || c == '*')
        return c;

    if (c == '\n' || c == EOF)
        return 0;

    return c;
}

int yyerror(char *s)
{
    printf("Invalid expression\n");
    return 0;
}

int main()
{
    printf("Enter expression: ");

    yyparse();

    printf("\nAST Traversals:\n");

    printf("Preorder  : ");
    preorder(root);

    printf("\nInorder   : ");
    inorder(root);

    printf("\nPostorder : ");
    postorder(root);

    printf("\n");

    return 0;
}
#include <stdio.h>
int main()
{
    int n, i;
    char result[10], arg1[10], arg2[10], op;
    printf("Enter number of TAC statements: ");
    scanf("%d", &n);
    printf("Enter TAC statements (e.g., t1 = a + b):\n");
    for(i = 0; i < n; i++)
    {
        scanf("%s = %s %c %s", result, arg1, &op, arg2);
        printf("\nMOV R0, %s\n", arg1);
        switch(op)
        {
            case '+':
                printf("ADD R0, %s\n", arg2);
                break;
            case '-':
                printf("SUB R0, %s\n", arg2);
                break;
            case '*':
                printf("MUL R0, %s\n", arg2);
                break;
            case '/':
                printf("DIV R0, %s\n", arg2);
                break;
            default:
                printf("Invalid operator\n");
        }
        printf("MOV %s, R0\n", result);
    }
    return 0;
}
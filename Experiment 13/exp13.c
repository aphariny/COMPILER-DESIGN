#include <stdio.h>
#include <string.h>

char stack[50], input[50], lhs[10], rhs[10][20];
int top = -1, ip = 0, n;

void reduce() {
    for (int r = 0; r < n; r++) {
        int len = strlen(rhs[r]);
        if (top + 1 >= len && strncmp(&stack[top - len + 1], rhs[r], len) == 0) {
            top -= len;
            stack[++top] = lhs[r];
            stack[top + 1] = '\0';
            printf("  %-12s %-12s Reduce %c->%s\n", stack, &input[ip], lhs[r], rhs[r]);
            r = -1; // Reset loop to check for consecutive reductions
        }
    }
}

int main() {
    printf("Enter rule count: ");
    scanf("%d", &n);

    printf("Enter rules (e.g. E=E+E):\n");
    for (int i = 0; i < n; i++) scanf(" %c=%s", &lhs[i], rhs[i]);

    printf("Enter string: ");
    scanf("%s", input);

    printf("\n  %-12s %-12s Action\n---------------------------------\n", "Stack", "Input");

    while (input[ip] != '\0') {
        stack[++top] = input[ip++];
        stack[top + 1] = '\0';
        printf("  %-12s %-12s Shift\n", stack, &input[ip]);
        reduce();
    }
    reduce();

    if (top == 0 && stack[0] == lhs[0])
        printf("---------------------------------\nResult: ACCEPTED\n");
    else
        printf("---------------------------------\nResult: REJECTED\n");

    return 0;
}
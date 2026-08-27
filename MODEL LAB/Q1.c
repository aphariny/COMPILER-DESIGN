#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char non_terminal;
    char rhs[100];
    char alpha[50][50], beta[50][50];
    int num_alpha = 0, num_beta = 0;

    printf("Enter Non-Terminal: ");
    scanf(" %c", &non_terminal);

    printf("Enter RHS productions separated by '|' (e.g., E+T|T): ");
    scanf("%s", rhs);

    char *token = strtok(rhs, "|");
    while (token != NULL) {
        if (token[0] == non_terminal) {
            // Left-recursive branch: A -> A alpha
            strcpy(alpha[num_alpha++], token + 1);
        } else {
            // Non-left-recursive branch: A -> beta
            strcpy(beta[num_beta++], token);
        }
        token = strtok(NULL, "|");
    }

    if (num_alpha == 0) {
        printf("\nThe given grammar does not contain immediate left recursion.\n");
        return 0;
    }

    printf("\n--- Transformed Grammar Without Left Recursion ---\n");
    
    // Print A -> beta A'
    printf("%c -> ", non_terminal);
    for (int i = 0; i < num_beta; i++) {
        printf("%s%c'", beta[i], non_terminal);
        if (i < num_beta - 1) printf(" | ");
    }
    printf("\n");

    // Print A' -> alpha A' | e
    printf("%c' -> ", non_terminal);
    for (int i = 0; i < num_alpha; i++) {
        printf("%s%c' | ", alpha[i], non_terminal);
    }
    printf("e\n");

    return 0;
}
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_RULES 20
#define MAX_LEN 30

int main() {
    char stack[100];
    int top = -1;
    
    char input[100];
    int ip = 0;

    int n;
    char rules[MAX_RULES][MAX_LEN];

    printf("=== Dynamic Predictive / Recursive Parser ===\n\n");

    printf("Enter number of grammar rules: ");
    scanf("%d", &n);

    printf("Enter rules (e.g., E=TR, R=+TR, R=# for epsilon, F=i for id):\n");
    for (int i = 0; i < n; i++) {
        printf("Rule %d: ", i + 1);
        scanf("%s", rules[i]);
    }

    printf("\nEnter input string to parse: ");
    scanf("%s", input);

    // Append end marker '$' to input
    int len = strlen(input);
    input[len] = '$';
    input[len + 1] = '\0';

    // Push end marker '$' and Start Symbol (LHS of first rule) onto stack
    stack[++top] = '$';
    stack[++top] = rules[0][0];

    printf("\n--- Parsing Trace ---\n");
    printf("%-20s %-20s %-30s\n", "Stack", "Input", "Action");
    printf("-------------------------------------------------------------\n");

    while (top >= 0) {
        // Prepare current stack string for display
        char stackStr[100];
        for (int k = 0; k <= top; k++) stackStr[k] = stack[k];
        stackStr[top + 1] = '\0';

        char X = stack[top];     // Top of stack
        char a = input[ip];      // Current input symbol

        // Case 1: Match terminal with input
        if (X == a) {
            if (X == '$') {
                printf("%-20s %-20s %-30s\n", stackStr, &input[ip], "ACCEPT");
                printf("-------------------------------------------------------------\n");
                printf("\nResult: SUCCESS (String Accepted!)\n");
                return 0;
            }
            printf("%-20s %-20s Match '%c'\n", stackStr, &input[ip], X);
            top--;
            ip++;
        }
        // Case 2: Top of stack is a Non-Terminal
        else if (isupper(X)) {
            int ruleFound = -1;

            // Search for a matching production rule
            for (int i = 0; i < n; i++) {
                if (rules[i][0] == X) {
                    // Check direct match or first character match
                    if (rules[i][2] == a || rules[i][2] == '#' || isupper(rules[i][2])) {
                        ruleFound = i;
                        break;
                    }
                }
            }

            if (ruleFound != -1) {
                printf("%-20s %-20s Apply %s\n", stackStr, &input[ip], rules[ruleFound]);
                top--; // Pop LHS

                // Push RHS symbols in reverse order (if not epsilon '#')
                int rhsLen = strlen(rules[ruleFound]);
                if (rules[ruleFound][2] != '#') {
                    for (int k = rhsLen - 1; k >= 2; k--) {
                        stack[++top] = rules[ruleFound][k];
                    }
                }
            } else {
                printf("%-20s %-20s Error: No production rule found\n", stackStr, &input[ip]);
                printf("-------------------------------------------------------------\n");
                printf("\nResult: REJECTED (Syntax Error!)\n");
                return 0;
            }
        }
        // Case 3: Terminal mismatch
        else {
            printf("%-20s %-20s Error: Mismatch\n", stackStr, &input[ip]);
            printf("-------------------------------------------------------------\n");
            printf("\nResult: REJECTED (Syntax Error!)\n");
            return 0;
        }
    }

    return 0;
}
#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_RULES 20
#define MAX_LEN 30

int n;
char production[MAX_RULES][MAX_LEN];
char result[20];

// Helper function to add a symbol without duplicates
void addToResult(char val) {
    int k;
    for (k = 0; result[k] != '\0'; k++) {
        if (result[k] == val) return;
    }
    result[k] = val;
    result[k + 1] = '\0';
}

// Helper to compute FIRST set for FOLLOW logic
void findFirst(char ch) {
    int j, k;

    if (!isupper(ch)) {
        addToResult(ch);
        return;
    }

    for (j = 0; j < n; j++) {
        if (production[j][0] == ch) {
            if (production[j][2] == '#') {
                addToResult('#');
            } else {
                k = 2;
                while (production[j][k] != '\0') {
                    char symbol = production[j][k];
                    int initialLen = strlen(result);

                    findFirst(symbol);

                    int hasEpsilon = 0;
                    for (int m = initialLen; result[m] != '\0'; m++) {
                        if (result[m] == '#') {
                            hasEpsilon = 1;
                            break;
                        }
                    }

                    if (!hasEpsilon) break;
                    k++;
                }
            }
        }
    }
}

// Function to compute FOLLOW set applying standard rules
void findFollow(char ch) {
    int i, j;

    // RULE 1: Add '$' to FOLLOW of the start symbol (LHS of 1st rule)
    if (production[0][0] == ch) {
        addToResult('$');
    }

    // Search for non-terminal 'ch' on the RHS of all productions
    for (i = 0; i < n; i++) {
        for (j = 2; production[i][j] != '\0'; j++) {
            if (production[i][j] == ch) {

                // If symbol exists after 'ch' (Rule 2: A -> alpha B beta)
                if (production[i][j + 1] != '\0') {
                    char nextSymbol = production[i][j + 1];

                    // If next symbol is terminal
                    if (!isupper(nextSymbol)) {
                        addToResult(nextSymbol);
                    } 
                    // If next symbol is non-terminal, add FIRST(nextSymbol)
                    else {
                        char tempFirst[20] = "";
                        int prevLen = strlen(result);
                        
                        findFirst(nextSymbol);

                        // Check if FIRST(nextSymbol) had epsilon '#'
                        int hasEpsilon = 0;
                        for (int m = prevLen; result[m] != '\0'; m++) {
                            if (result[m] == '#') {
                                hasEpsilon = 1;
                                // Remove '#' from result because epsilon is never in FOLLOW set
                                for (int r = m; result[r] != '\0'; r++) {
                                    result[r] = result[r + 1];
                                }
                                break;
                            }
                        }

                        // RULE 3: If FIRST(beta) contains epsilon, add FOLLOW(LHS)
                        if (hasEpsilon && production[i][0] != ch) {
                            findFollow(production[i][0]);
                        }
                    }
                } 
                // RULE 3: If 'ch' is at the end of RHS (A -> alpha B)
                else if (production[i][0] != ch) {
                    findFollow(production[i][0]);
                }
            }
        }
    }
}

int main() {
    int i, j;
    char nonTerminals[20] = "";
    int ntCount = 0;

    printf("Enter number of production rules: ");
    scanf("%d", &n);

    printf("Enter the %d production rules (e.g., S=AaAb, A=#):\n", n);
    for (i = 0; i < n; i++) {
        printf("Rule %d: ", i + 1);
        scanf("%s", production[i]);

        // Collect unique Non-Terminals from LHS
        char lhs = production[i][0];
        int exists = 0;
        for (j = 0; j < ntCount; j++) {
            if (nonTerminals[j] == lhs) {
                exists = 1;
                break;
            }
        }
        if (!exists) {
            nonTerminals[ntCount++] = lhs;
        }
    }

    printf("\n=== FOLLOW SET RESULTS ===\n");
    for (i = 0; i < ntCount; i++) {
        result[0] = '\0'; // Clear result buffer
        findFollow(nonTerminals[i]);

        printf("FOLLOW(%c) = { ", nonTerminals[i]);
        for (j = 0; result[j] != '\0'; j++) {
            printf("%c", result[j]);
            if (result[j + 1] != '\0') {
                printf(", ");
            }
        }
        printf(" }\n");
    }

    return 0;
}
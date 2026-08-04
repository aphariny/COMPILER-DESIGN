#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_RULES 10
#define MAX_LEN 20

int n = 4; // Total production rules
char production[MAX_RULES][MAX_LEN];
char result[20];

// Helper function to add a character to the result set without duplicates
void addToResult(char val) {
    int k;
    for (k = 0; result[k] != '\0'; k++) {
        if (result[k] == val) return;
    }
    result[k] = val;
    result[k + 1] = '\0';
}

// Function to compute FIRST set for a single symbol
void findFirst(char ch) {
    int j;

    if (!isupper(ch)) {
        addToResult(ch);
        return;
    }

    for (j = 0; j < n; j++) {
        if (production[j][0] == ch) {
            if (production[j][2] == '#') {
                addToResult('#');
            } else {
                int k = 2;
                while (production[j][k] != '\0') {
                    char symbol = production[j][k];
                    if (!isupper(symbol)) {
                        addToResult(symbol);
                        break;
                    } else {
                        int derivesEpsilon = 0;
                        for (int p = 0; p < n; p++) {
                            if (production[p][0] == symbol && production[p][2] == '#') {
                                derivesEpsilon = 1;
                                break;
                            }
                        }
                        if (derivesEpsilon) {
                            k++;
                        } else {
                            findFirst(symbol);
                            break;
                        }
                    }
                }
            }
        }
    }
}

// Function to compute FOLLOW set
void findFollow(char ch) {
    int i, j;

    // Rule 1: Always add '$' to FOLLOW of Start Symbol 'S'
    if (production[0][0] == ch) {
        addToResult('$');
    }

    // Search for 'ch' on the RHS of all productions
    for (i = 0; i < n; i++) {
        for (j = 2; production[i][j] != '\0'; j++) {
            if (production[i][j] == ch) {
                
                // If there is a symbol after 'ch'
                if (production[i][j + 1] != '\0') {
                    char nextSymbol = production[i][j + 1];
                    
                    // If next symbol is terminal, add it directly
                    if (!isupper(nextSymbol)) {
                        addToResult(nextSymbol);
                    } 
                    // If next symbol is non-terminal, add FIRST(nextSymbol)
                    else {
                        findFirst(nextSymbol);
                    }
                } 
                // If 'ch' is at the very end of RHS and not the LHS head, compute FOLLOW(LHS)
                else if (production[i][0] != ch) {
                    findFollow(production[i][0]);
                }
            }
        }
    }
}

int main() {
    int i, choice;
    char c;

    // Grammar setup:
    // S -> AaAb | BbBa
    // A -> #
    // B -> #
    strcpy(production[0], "S=AaAb");
    strcpy(production[1], "S=BbBa");
    strcpy(production[2], "A=#");
    strcpy(production[3], "B=#");

    printf("=== FOLLOW Set Calculation ===\n\n");
    printf("Grammar:\n");
    printf("  S -> AaAb | BbBa\n");
    printf("  A -> #  (where # denotes Epsilon/€)\n");
    printf("  B -> #\n\n");

    do {
        printf("Enter Non-Terminal (S, A, or B): ");
        scanf(" %c", &c);

        result[0] = '\0'; // Clear buffer
        findFollow(c);

        printf("FOLLOW(%c) = { ", c);
        for (i = 0; result[i] != '\0'; i++) {
            printf("%c", result[i]);
            if (result[i + 1] != '\0') {
                printf(", ");
            }
        }
        printf(" }\n\n");

        printf("Check another symbol? (1 = Yes / 0 = No): ");
        scanf("%d", &choice);
        printf("\n");

    } while (choice == 1);

    return 0;
}
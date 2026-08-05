#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_RULES 20
#define MAX_LEN 30

int n;
char production[MAX_RULES][MAX_LEN];
char result[20];

void addToResult(char val) {
    int k;
    for (k = 0; result[k] != '\0'; k++) {
        if (result[k] == val) return;
    }
    result[k] = val;
    result[k + 1] = '\0';
}

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

int main() {
    int i, j;
    char nonTerminals[20] = "";
    int ntCount = 0;

    printf("Enter number of production rules: ");
    scanf("%d", &n);

    printf("Enter the %d production rules (e.g., E=aAb, A=#):\n", n);
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

    printf("\n=== FIRST SET RESULTS ===\n");
    for (i = 0; i < ntCount; i++) {
        result[0] = '\0'; // Reset result buffer
        findFirst(nonTerminals[i]);

        printf("FIRST(%c) = { ", nonTerminals[i]);
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
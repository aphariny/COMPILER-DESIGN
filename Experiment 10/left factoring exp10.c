#include <stdio.h>
#include <string.h>

void eliminateLeftFactoring() {
    char p1[] = "iEtS";
    char p2[] = "iEtSeS";
    char commonPrefix[20] = "";
    int i = 0;

    // Find longest common prefix between iEtS and iEtSeS
    while (p1[i] != '\0' && p2[i] != '\0' && p1[i] == p2[i]) {
        commonPrefix[i] = p1[i];
        i++;
    }
    commonPrefix[i] = '\0';

    printf("Common Prefix detected: %s\n\n", commonPrefix);
    printf("Resulting Grammar:\n");
    printf("  S  -> %s S' | a\n", commonPrefix);
    printf("S' -> %s | #\n", &p2[i]);// Prints the remaining suffix ('eS')
    printf("  E  -> b\n");
}

int main() {
    printf("=== Left Factoring Elimination ===\n\n");
    printf("Grammar:\n");
    printf("  S -> iEtS | iEtSeS | a\n");
    printf("  E -> b\n\n");

    eliminateLeftFactoring();

    return 0;
}
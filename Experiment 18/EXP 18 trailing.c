#include <stdio.h>
#include <ctype.h>
#include <string.h>

int n;
char lhs[10], rhs[10][20], trail[10][20];

void add(int idx, char c) {
    if (c == '#' || c == '\0' || strchr(trail[idx], c)) return;
    int len = strlen(trail[idx]);
    trail[idx][len] = c; trail[idx][len + 1] = '\0';
}

void getTrail(int idx) {
    for (int i = 0; i < n; i++) {
        if (lhs[i] == lhs[idx]) {
            int len = strlen(rhs[i]);
            if (!isupper(rhs[i][len - 1])) add(idx, rhs[i][len - 1]);
            else if (len > 1 && !isupper(rhs[i][len - 2])) add(idx, rhs[i][len - 2]);
            if (isupper(rhs[i][len - 1]) && rhs[i][len - 1] != lhs[idx]) {
                for (int j = 0; j < n; j++) 
                    if (lhs[j] == rhs[i][len - 1]) { getTrail(j); for (int k = 0; trail[j][k]; k++) add(idx, trail[j][k]); break; }
            }
        }
    }
}

int main() {
    printf("Enter rule count: "); scanf("%d", &n);
    printf("Enter rules (e.g. E=E+T, F=i):\n");
    for (int i = 0; i < n; i++) scanf(" %c=%s", &lhs[i], rhs[i]);

    printf("\n=== TRAILING SETS ===\n");
    for (int i = 0; i < n; i++) {
        int done = 0;
        for (int j = 0; j < i; j++) if (lhs[j] == lhs[i]) done = 1;
        if (!done) {
            getTrail(i);
            printf("TRAILING(%c) = { ", lhs[i]);
            for (int k = 0; trail[i][k]; k++) printf("%c%s", trail[i][k], trail[i][k+1] ? ", " : "");
            printf(" }\n");
        }
    }
    return 0;
}
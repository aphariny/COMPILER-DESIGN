#include <stdio.h>
#include <ctype.h>
#include <string.h>

int n;
char lhs[10], rhs[10][20], lead[10][20];

void add(int idx, char c) {
    if (c == '#' || c == '\0' || strchr(lead[idx], c)) return;
    int len = strlen(lead[idx]);
    lead[idx][len] = c; lead[idx][len + 1] = '\0';
}

void getLead(int idx) {
    for (int i = 0; i < n; i++) {
        if (lhs[i] == lhs[idx]) {
            if (!isupper(rhs[i][0])) add(idx, rhs[i][0]);
            else if (rhs[i][1] && !isupper(rhs[i][1])) add(idx, rhs[i][1]);
            if (isupper(rhs[i][0]) && rhs[i][0] != lhs[idx]) {
                for (int j = 0; j < n; j++) 
                    if (lhs[j] == rhs[i][0]) { getLead(j); for (int k = 0; lead[j][k]; k++) add(idx, lead[j][k]); break; }
            }
        }
    }
}

int main() {
    printf("Enter rule count: "); scanf("%d", &n);
    printf("Enter rules (e.g. E=E+T, F=i):\n");
    for (int i = 0; i < n; i++) scanf(" %c=%s", &lhs[i], rhs[i]);

    printf("\n=== LEADING SETS ===\n");
    for (int i = 0; i < n; i++) {
        int done = 0;
        for (int j = 0; j < i; j++) if (lhs[j] == lhs[i]) done = 1;
        if (!done) {
            getLead(i);
            printf("LEADING(%c) = { ", lhs[i]);
            for (int k = 0; lead[i][k]; k++) printf("%c%s", lead[i][k], lead[i][k+1] ? ", " : "");
            printf(" }\n");
        }
    }
    return 0;
}
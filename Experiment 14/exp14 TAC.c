#include <stdio.h>
#include <string.h>
char expr[50], temp[50];
int temp_count = 1;
void generateTAC(char op) {
    for (int i = 0; expr[i] != '\0'; i++) {
        if (expr[i] == op) {
            printf("t%d = %c %c %c\n", temp_count, expr[i - 1], op, expr[i + 1]);
            expr[i - 1] = 't';
            expr[i] = temp_count + '0';
            int j = i + 1;
            while (expr[j + 1] != '\0') {
                expr[j] = expr[j + 1];
                j++;
            }
            expr[j] = '\0';
            
            temp_count++;
            i = 0; 
        }
    }
}
int main() {
    printf("Enter expression : ");
    scanf("%s", expr);
    printf("\n=== Three Address Code  ===\n");
    generateTAC('/');
    generateTAC('*');
    generateTAC('+');
    generateTAC('-');
    if (expr[1] == '=') {
        printf("%c = %c%c\n", expr[0], expr[2], expr[3]);
    }
    return 0;
}
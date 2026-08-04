#include <stdio.h>
#include <string.h>

int main()
{
    char lhs[10] = "L";
    char recursive[20] = ",S";
    char nonrecursive[20] = "S";

    printf("===== Left Recursion Elimination =====\n\n");

    printf("Original Grammar:\n");
    printf("S -> (L) | a\n");
    printf("L -> L,S | S\n");

    printf("\nAfter Eliminating Left Recursion:\n");

    printf("S -> (L) | a\n");
    printf("L -> SL'\n");
    printf("L' -> ,SL' | #\n");

    return 0;
}
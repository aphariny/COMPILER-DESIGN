#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_RULES 10
#define MAX_LEN 20

int n = 4;
char production[MAX_RULES][MAX_LEN];
char result[20];

// Add symbol to FIRST set (avoid duplicates)
void addToResult(char val)
{
    int k;

    for(k = 0; result[k] != '\0'; k++)
    {
        if(result[k] == val)
            return;
    }

    result[k] = val;
    result[k + 1] = '\0';
}

// Find FIRST of a symbol
void findFirst(char ch)
{
    int j, k, p;

    // If terminal
    if(!isupper(ch))
    {
        addToResult(ch);
        return;
    }

    // Search all productions of the non-terminal
    for(j = 0; j < n; j++)
    {
        if(production[j][0] == ch)
        {
            // Direct epsilon production
            if(production[j][2] == '#')
            {
                addToResult('#');
            }
            else
            {
                k = 2;

                while(production[j][k] != '\0')
                {
                    char symbol = production[j][k];

                    // Terminal found
                    if(!isupper(symbol))
                    {
                        addToResult(symbol);
                        break;
                    }

                    // Check whether the non-terminal derives epsilon
                    int derivesEpsilon = 0;

                    for(p = 0; p < n; p++)
                    {
                        if(production[p][0] == symbol &&
                           production[p][2] == '#')
                        {
                            derivesEpsilon = 1;
                            break;
                        }
                    }

                    if(derivesEpsilon)
                    {
                        k++;       // Continue to next symbol
                    }
                    else
                    {
                        findFirst(symbol);
                        break;
                    }
                }
            }
        }
    }
}

int main()
{
    int i, choice;
    char c;

    // Grammar
    strcpy(production[0], "S=AaAb");
    strcpy(production[1], "S=BbBa");
    strcpy(production[2], "A=#");
    strcpy(production[3], "B=#");

    printf("=== FIRST Set Calculation ===\n\n");

    printf("Grammar:\n");
    printf("S -> AaAb | BbBa\n");
    printf("A -> #   (# denotes Epsilon)\n");
    printf("B -> #\n\n");

    do
    {
        printf("Enter Non-Terminal (S, A, or B): ");
        scanf(" %c", &c);

        c = toupper(c);      // Accept lowercase input too

        result[0] = '\0';

        findFirst(c);

        printf("FIRST(%c) = { ", c);

        for(i = 0; result[i] != '\0'; i++)
        {
            printf("%c", result[i]);

            if(result[i + 1] != '\0')
                printf(", ");
        }

        printf(" }\n\n");

        printf("Check another symbol? (1 = Yes / 0 = No): ");
        scanf("%d", &choice);

        printf("\n");

    } while(choice == 1);

    return 0;
}
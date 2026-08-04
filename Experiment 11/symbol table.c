#include <stdio.h>
#include <string.h>

struct Symbol
{
    char name[20];
    char type[20];
    int size;
};

struct Symbol table[20];
int count = 0;

void insert()
{
    printf("\nEnter Symbol Name: ");
    scanf("%s", table[count].name);

    printf("Enter Data Type: ");
    scanf("%s", table[count].type);

    printf("Enter Size: ");
    scanf("%d", &table[count].size);

    count++;

    printf("\nSymbol Inserted Successfully!\n");
}

void display()
{
    int i;

    if(count == 0)
    {
        printf("\nSymbol Table is Empty!\n");
        return;
    }

    printf("\n-----------------------------------------\n");
    printf("Symbol\t\tType\t\tSize\n");
    printf("-----------------------------------------\n");

    for(i = 0; i < count; i++)
    {
        printf("%s\t\t%s\t\t%d\n",
               table[i].name,
               table[i].type,
               table[i].size);
    }
}

void search()
{
    char key[20];
    int i, found = 0;

    printf("\nEnter Symbol to Search: ");
    scanf("%s", key);

    for(i = 0; i < count; i++)
    {
        if(strcmp(key, table[i].name) == 0)
        {
            printf("\nSymbol Found!\n");
            printf("Name : %s\n", table[i].name);
            printf("Type : %s\n", table[i].type);
            printf("Size : %d\n", table[i].size);
            found = 1;
            break;
        }
    }

    if(!found)
        printf("\nSymbol Not Found!\n");
}

void deleteSymbol()
{
    char key[20];
    int i, j, found = 0;

    printf("\nEnter Symbol to Delete: ");
    scanf("%s", key);

    for(i = 0; i < count; i++)
    {
        if(strcmp(key, table[i].name) == 0)
        {
            found = 1;

            for(j = i; j < count - 1; j++)
            {
                table[j] = table[j + 1];
            }

            count--;

            printf("\nSymbol Deleted Successfully!\n");
            break;
        }
    }

    if(!found)
        printf("\nSymbol Not Found!\n");
}

int main()
{
    int choice;

    do
    {
        printf("\n===== SYMBOL TABLE =====\n");
        printf("1. Insert\n");
        printf("2. Display\n");
        printf("3. Search\n");
        printf("4. Delete\n");
        printf("5. Exit\n");

        printf("\nEnter your choice: ");
        scanf("%d", &choice);

        switch(choice)
        {
            case 1:
                insert();
                break;

            case 2:
                display();
                break;

            case 3:
                search();
                break;

            case 4:
                deleteSymbol();
                break;

            case 5:
                printf("\nExiting Program...\n");
                break;

            default:
                printf("\nInvalid Choice!\n");
        }

    } while(choice != 5);

    return 0;
}
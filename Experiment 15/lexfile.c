#include <stdio.h>
#include <ctype.h>
int main()
{
    FILE *fp;
    char ch;
    int characters = 0, words = 0, lines = 0, inWord = 0;
    fp = fopen("input.txt", "r");
    if (fp == NULL)
    {
        printf("File not found.\n");
        return 1;
    }
    while ((ch = fgetc(fp)) != EOF)
    {
        characters++;
        if (ch == '\n')
            lines++;
        if (isspace(ch))
            inWord = 0;
        else if (inWord == 0)
        {
            words++;
            inWord = 1;
        }
    }
    fclose(fp);
    printf("Number of Characters = %d\n", characters);
    printf("Number of Words      = %d\n", words);
    printf("Number of Lines      = %d\n", lines);
    return 0;
}
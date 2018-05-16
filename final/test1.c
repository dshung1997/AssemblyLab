#include <stdio.h>

int main()
{
    char a[10];
    printf("\"%s\"\n", a);
    a[0] = 'a';
    a[1] = 'b';
    a[2] = 'c';
    a[3] = '\0';
    printf("\"%s\"\n", a);

    char b[5] = "";
    printf("b : \"%s\"\n", b);


    return 0;
}
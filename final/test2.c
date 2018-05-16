#include <stdio.h>


int check(char* test);

int main()
{
    FILE* f = fopen("textTest.txt", "r");

    while(!feof(f))
    {
        
        char test[100];
        fscanf(f, "%[^\n]%*c", test);
        
        int k = check(test);
        if(k == -1)
        {
            printf("_____________LOI_____________ \"%s\"\n", test);
        }
        else 
        {
            printf("_____________OKOKOKOK________ \"%s\"\n", test);
        }
        
        if(feof(f))
        {   
            break;
        }
        
    }

    fclose(f);
    return 0;
}

int check(char* test)
{
    // add $t1,$t2,$t3
    //char test[] = "    add     $11,    ,  $t2,    $t3                   ,";
    char name[10] = "";
    char pa1[10] = "";
    char pa2[10] ="";
    char pa3[10] =  "";

    int i = 0; 
    int iName = 0;
    int iPa1 = 0;
    int iPa2 = 0;
    int iPa3 = 0;

    while(test[i] != '\0' && test[i] == ' ')
    {
        i += 1;
    }

    printf("%d\n\"%s\"\n", __LINE__, test+i);

    int flag = 0;
    // get ins name
    while(test[i] != '\0')
    {
        if('a' <= test[i] && test[i] <= 'z')
        {
            name[iName] = test[i];
            iName += 1;
            name[iName] = '\0';
        }
        else if(test[i] == ' ')
        {
            break;
        }
        else 
        {
            flag = 1;
            break;
        }
        
        i += 1;
    }
    
    if(flag == 1)
    {
        printf("__%d__\n", __LINE__);
        printf("Loi1\n");
        return -1;
    }
    printf("__%d__\n", __LINE__);
    printf("\"%s\"\n", name);
    
    while(test[i] != '\0' && test[i] == ' ')
    {
        i += 1;
    }
    printf("\"%s\"\n", test+i);
    int flag1 = 0;
    while(test[i] != '\0')
    {
        if(test[i] == ' ')
        {
            flag1 = 1; // behind this space character must be a comma.
        }
        else if(test[i] == ',')
        {
            flag1 = 2;
        }
        else if(('a' <= test[i] && test[i] <= 'z') || (test[i] == '$') || ('0' <= test[i] && test[i] <= '9'))
        {
            pa1[iPa1] = test[i];
            iPa1 += 1;
            pa1[iPa1] = '\0';
        }
        else
        {
            flag1 = 3;
        }

        i += 1;

        if(flag1 != 0) break;
    }
    printf("__%d__\n", __LINE__);
    printf("\"%s\"\n", pa1);

    if(flag1 == 3)
    {printf("__%d__\n", __LINE__);
        printf("Loi2\n");
        return -1;
    }

    else if(flag1 == 1)
    {
        while(test[i] != '\0' && test[i] == ' ')
        {
            i += 1;
        }

        if(test[i] != ',' && test[i] != '\0')
        {printf("__%d__\n", __LINE__);
            printf("Loi3\n");
            return -1;
        }
        else if(test[i] == '\0')
        {printf("__%d__\n", __LINE__);
            printf("Het roi\n");
        }
        else if(test[i] == ',')
        {
            i += 1;
            while(test[i] != '\0' && test[i] == ' ')
            {
                i += 1;
            }
        }
    }
    else if(flag1 == 2)
    {
        while(test[i] != '\0' && test[i] == ' ')
        {
            i += 1;
        }
    }



    int flag2 = 0;
    while(test[i] != '\0')
    {
        if(test[i] == ' ')
        {
            flag2 = 1; // behind this space character must be a comma.
        }
        else if(test[i] == ',')
        {
            flag2 = 2;
        }
        else if(('a' <= test[i] && test[i] <= 'z') || (test[i] == '$') || ('0' <= test[i] && test[i] <= '9'))
        {
            pa2[iPa2] = test[i];
            iPa2 += 1;
            pa2[iPa2] = '\0';
        }
        else
        {
            flag2 = 3;
        }

        i += 1;

        if(flag2 != 0) break;
    }
    printf("__%d__\n", __LINE__);
    printf("\"%s\"\n", pa2);

    if(flag2 == 3)
    {printf("__%d__\n", __LINE__);
        printf("Loi4\n");
        return -1;
    }
    else if(flag2 == 1)
    {
        while(test[i] != '\0' && test[i] == ' ')
        {
            i += 1;
        }

        if(test[i] != ',' && test[i] != '\0')
        {printf("__%d__\n", __LINE__);
            printf("Loi10\n");
            return -1;
        }
        else if(test[i] == '\0')
        {printf("__%d__\n", __LINE__);
            printf("Het roi 1\n");
        }
        else if(test[i] == ',')
        {
            i += 1;
            while(test[i] != '\0' && test[i] == ' ')
            {
                i += 1;
            }
        }
    }
    else if(flag2 == 2)
    {printf("__%d__\n", __LINE__);
        printf("__%d__\n", __LINE__);
        while(test[i] != '\0' && test[i] == ' ')
        {
            i += 1;
        }
    }


    int flag3 = 0;
    while(test[i] != '\0')
    {printf("__%d__\n", __LINE__);
        printf("%d - %c\n", __LINE__, test[i]);
        if(test[i] == ' ')
        {
            flag3 = 1; // behind this space character must be a comma.
        }
        else if(test[i] == ',')
        {
            flag3 = 2;
        }
        else if(('a' <= test[i] && test[i] <= 'z') || (test[i] == '$') || ('0' <= test[i] && test[i] <= '9'))
        {
            pa3[iPa3] = test[i];
            iPa3 += 1;
            pa3[iPa3] = '\0';
        }
        else
        {
            flag3 = 3;
        }

        i += 1;

        if(flag3 != 0) break;
    }
    printf("__%d__\n", __LINE__);
    printf("\"%s\"\n", pa3);

    if(flag3 == 0) 
    {
        printf("__%d__\n", __LINE__);
            printf("Het roi 4\n");
    }

    if(flag3 == 3 || flag3 == 2)
    {printf("__%d__\n", __LINE__);
        printf("Loi5\n");
        return -1;
    }
    else if(flag3 == 1)
    {
        while(test[i] != '\0' && test[i] == ' ')
        {
            i += 1;
        }

        if(test[i] == '\0')
        {printf("__%d__\n", __LINE__);
            printf("Het roi 2\n");
        }
        else
        {printf("__%d__\n", __LINE__);
            printf("Loi6\n");
            return -1;
        }
    }












    

    // while(test[i] != '\0' && test[i] == ' ')
    // {
    //     i += 1;
    // }

    // int flagSpace = 0;
    // while(test[i] != '\0')
    // {
    //     if(test[i] == ' ')
    //     {
    //         flagSpace = 1;
    //         break;
    //     }

    //     else if(test[i] == ',')
    //     {
    //         break;
    //     }
    //     else
    //     {
    //         pa1[iPa1] = test[i];
    //         iPa1 += 1;
    //     }
        
    //     i += 1;
    // }

    // while(test[i] != '\0' && test[i] == ' ')
    // {
    //     i += 1;
    // }

    // if(test[i] != ',') printf("Loi2\n");
    // else printf("\"Phay\"\n");

    // while(test[i] != '\0' && test[i] == ' ')
    // {
    //     i += 1;
    // }

    



      
    return 0;
}
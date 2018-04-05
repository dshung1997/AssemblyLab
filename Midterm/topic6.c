#include <stdio.h>

int main(void) {
	
	int n = 5;
	int A = 2*n-1;
	int B = n-1;
	
	
	for(int i = 0; i < B; i++)
	{
		for(int j = 0; j < n-i-1; j++) printf(" ");
		
		printf("*");
		
		for(int j = 0; j < (2*i-1); j++) printf(" ");
	 
		if(i != 0) printf("*");
		
		printf("\n");
	}
	
	for(int i = 0; i < A; i++) printf("*");
	
	printf("\n\n");
	
	for(int i = 0; i < B; i++)
	{
		for(int j = 0; j < A; j++)
		{
			if(j == (n-i-1) || j == (n+i-1)) printf("*");
			else printf(" ");
		}
		
		printf("\n");
	}
	
	for(int i = 0; i < A; i++) printf("*");
	
	return 0;
}

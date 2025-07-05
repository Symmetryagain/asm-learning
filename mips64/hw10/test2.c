// main.c
#include <stdio.h>

void reverse(int* a, int length);

int main() {
    int arr[] = {1, 2, 3, 4, 5};
    int length = sizeof(arr)/sizeof(arr[0]);
    
    reverse(arr, length);
    
    printf("Result: ");
    for (int i = 0; i < length; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    return 0;
}
#include <stdio.h>



int main() {
    int n;
    int a[20];
    scanf("%d", &n);
    for(int i = 1; i <= n; ++i) scanf("%d", &a[i]);
    qsort(a, 1, n);
    for(int i = 1; i <= n; ++i) printf("%d ", a[i]);
    puts("");
    return 0;
}
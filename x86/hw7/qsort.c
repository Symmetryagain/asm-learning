#include <stdio.h>

void qsort(int a[], int l, int r) {
	int sd = a[(l + r) / 2], i = l, j = r;
	do {
		while(a[i] < sd) i++;
		while(a[j] > sd) j--;
		if(i <= j) {
            int tmp = a[i];
            a[i] = a[j], a[j] = tmp, i ++, j --;
        }
	} while(i <= j);
	if(l < j) qsort(a, l, j);
	if(i < r) qsort(a, i, r);
}
signed main(){
    int n, a[200];
	scanf("%d",&n);
	for(int i=1;i<=n;++i) scanf("%d",&a[i]);
	qsort(a, 1, n);
	for(int i=1;i<=n;++i) printf("%d ",a[i]);
    puts("");
	return 0;
}
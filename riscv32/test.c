#include <stdio.h>


int main() {
    // printf("%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n", 
    // 	0 == 0U,
    //     -1 < 0,
    //     -1 < 0U,
    //     2147483647 > -2147483647-1,
    //     2147483647U > -2147483647-1,
    //     2147483647 > (int) 2147483648U,
    //     -1 > -2,
    //     (unsigned) -1 > -2);
    short si = -32768;
    unsigned short usi = si;
    int i = si;
    unsigned ui = usi ;
    printf("%hd %hu %d %u\n", si, usi, i, ui);
    return 0;
}
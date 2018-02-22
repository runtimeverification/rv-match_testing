// floatprintf.c
#include <stdio.h>
int main() {
	float a = 1.55e1;
	float b = 0x1.fp3;
	float c = 2.1;
	printf("%.6f\n", a);
	printf("%.6f\n", b);
	printf("%.5f\n", c);
	return 0;
}

// commonfunctionattributes.c
// https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
#include "stdlib.h"
int main () {
	void __f () { }
	void f () __attribute__ ((weak, alias ("__f")));
	void f () __attribute__ ((weak, aligned (8)));
	void* my_memalign(size_t, size_t) __attribute__((alloc_align(1)));
	void* my_calloc(size_t, size_t) __attribute__((alloc_size(1,2)));
	void* my_realloc(void*, size_t) __attribute__((alloc_size(2)));
	return 0;
}

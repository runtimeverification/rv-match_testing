// returnaddress.c
// runtime
// https://gcc.gnu.org/onlinedocs/gcc/Return-Address.html#Return-Address
#include <stdio.h>
int main(int ac, char **av) {
  printf("%p\n", __builtin_return_address(0));
  return 0;
}

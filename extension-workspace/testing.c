// testing.c
// https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
int main () {
    return test(5);
}
int test(int i) {
  switch(i)
  {
  case 1 ... 3:
    printf("hi");
  }
}

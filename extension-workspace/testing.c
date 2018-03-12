// testing.c
// https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
int main () {
enum E {
  oldval __attribute__((deprecated)),
  newval
};

int
fn (void)
{
  return oldval;
}
}

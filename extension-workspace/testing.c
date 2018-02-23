// testing.c
// https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
int main () {
	static struct foo x = (struct foo) {1, 'a', 'b'};
static int y[] = (int []) {1, 2, 3};
static int z[] = (int [3]) {1};
	return 0;
}

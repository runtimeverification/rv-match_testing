// casttounion.c
// https://gcc.gnu.org/onlinedocs/gcc/Cast-to-Union.html#Cast-to-Union
int main () {
	union foo { int i; double d; };
	int x;
	double y;
	union foo u;
	u = (union foo) x;
	u = (union foo) y;
	return 0;
}

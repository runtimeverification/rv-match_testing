// testing.c
// https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
int main() {
	_Complex double x;
	__complex__ double y;
	double a = __real__ y;
	double b = __imag__ x;
	return 0;
}

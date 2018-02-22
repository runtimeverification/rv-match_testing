// complex.c
// https://gcc.gnu.org/onlinedocs/gcc/Complex.html#Complex
int main() {
	_Complex double x;
	__complex__ double y;
	double a = __real__ y;
	double b = __imag__ x;
	return 0;
}

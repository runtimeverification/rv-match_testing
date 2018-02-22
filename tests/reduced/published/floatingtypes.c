// floatingtypes.c
// https://gcc.gnu.org/onlinedocs/gcc/Floating-Types.html#Floating-Types
int main() {
	typedef _Complex float __attribute__((mode(TC))) _Complex128;
	typedef _Complex float __attribute__((mode(XC))) _Complex80;
	return 0;
}

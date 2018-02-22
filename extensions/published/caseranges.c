// caseranges.c
// https://gcc.gnu.org/onlinedocs/gcc/Case-Ranges.html#Case-Ranges
int main() {
	int i = 4;
	switch(i) {
		case 1 ... 5:
		i = 5;
	}
	return 0;
}

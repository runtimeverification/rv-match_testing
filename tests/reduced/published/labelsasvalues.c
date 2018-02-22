// labelsasvalues.c
// https://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html#Labels-as-Values
int main() {
	int i = 0;
	static const int array[] = { &&foo - &&foo, &&bar - &&foo,
                             &&hack - &&foo };
	goto *(&&foo + array[i]);
	hack:
	bar:
	foo:
	return 0;
}

// nestedfunctions.c
// https://gcc.gnu.org/onlinedocs/gcc/Nested-Functions.html#Nested-Functions
int main() {
    int x = 0;
    int y[ 5 ];
    hack(y, x);
    return 0;
}
void intermediate ( void (*storearg)(int, int), int size) {
    storearg(0, 0);
}
hack (int *array, int size) {
    void store (int index, int value) {
        array[index] = value;
    }
    intermediate (store, size);
}

// alignment.c
// Should be returning a 2?
// https://gcc.gnu.org/onlinedocs/gcc/Alignment.html#Alignment
int main() {
    struct foo { int x; char y; } foo1;
    int z = __alignof__ (foo1.x);
    return z;
}

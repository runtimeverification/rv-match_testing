// conditionals.c
// https://gcc.gnu.org/onlinedocs/gcc/Conditionals.html#Conditionals
int main() {
    int x = 1;
    int y = 1;
    y = x ? x : y;
    y = x ? : y;
    return 0;
}

// typeof.c
// https://gcc.gnu.org/onlinedocs/gcc/Typeof.html#Typeof
int main() {
    typeof (typeof (char *)[4]) y;
    return 0;
}

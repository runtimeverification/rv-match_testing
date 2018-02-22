// emptystructures.c
// runtime
// https://gcc.gnu.org/onlinedocs/gcc/Empty-Structures.html#Empty-Structures
int main() {
    struct empty {
    } believeme;
    char* kccneedsfixed = (char*)&believeme;
    kccneedsfixed = '7';
    return 0;
}

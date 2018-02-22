// zerolength.c
// https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html#Zero-Length
struct f1 {
    int x; int y[];
} f1 = { 1, { 2, 3, 4 } };
struct f2 {
    struct f1 f1; int data[3];
} f2 = { { 1 }, { 2, 3, 4 } };
int main() {
    return 0;
}

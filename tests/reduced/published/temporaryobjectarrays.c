// temporaryobjectarrays.c
// issue #415
int main(void) {
      union u2 {
            int x;
            char ca[2];
      };
      union u2 o2 = { .ca = "a" };
      return (0, o2).ca == o2.ca - 1;
}

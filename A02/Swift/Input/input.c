#include <stdio.h>

int main() {
    int a = @;
    int b = 20;
    float x = 15.5.76;
    const int limit = 10;

    if (a < b && limit >= 10) {
        a += 5;
    } else {
        b -= 5;
    }

    while (a != b) {
        a++;
        b--;
    }

    for (int i = 0; i < 10; i++) {
        x = x + 1.5;
    }

    /* block comment */
    return 0;
}

int main() {
    int a = 10;
    int b = 20;
    float x = 15.5;

    // comparison
    if (a < b) {
        a = a + 5;
    } else {
        b = b - 5;
    }

    while (a != b) {
        a = a + 1;
    }

    for (int i = 0; i < 10; i = i + 1) {
        x = x + 1.5;
    }

    if (a == b) {
        return 0;
    }

    return 1;
}
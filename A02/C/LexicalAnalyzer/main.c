#include <stdio.h>

#include "Lexer.h"

int main(void) {
    struct Lexer lexer;

    if (Lexer_init(&lexer, "Input/input.c") != 0) {
        fprintf(stderr, "Failed to initialize lexer\n");
        return 1;
    }

    Lexer_printTokens(&lexer);
    Lexer_printErrors(&lexer);

    Lexer_destroy(&lexer);

    return 0;
}
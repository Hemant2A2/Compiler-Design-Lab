#!/bin/bash
echo "Building and running the C Lexer..."
if flex lexer_C.l && gcc lex.yy.c -o c_lexer; then
    ./c_lexer
else
    echo "Compilation failed!"
fi
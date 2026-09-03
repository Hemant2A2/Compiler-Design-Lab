#!/bin/bash
echo "Building and running the Swift Lexer..."
if flex lexer_swift.l && gcc lex.yy.c -o swift_lexer; then
    ./swift_lexer
else
    echo "Compilation failed!"
fi
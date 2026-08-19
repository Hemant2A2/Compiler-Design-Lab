#!/bin/bash

set -e

# Always run from the A02 directory
cd "$(dirname "$0")"

EXECUTABLE="lexer"
OUTPUT_DIR="Output"
OUTPUT_FILE="$OUTPUT_DIR/output.txt"

# Create Output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Remove any previous executable
rm -f "$EXECUTABLE"

echo "Compiling lexer..."

gcc -Wall -Wextra -std=c17 \
    LexicalAnalyzer/main.c \
    LexicalAnalyzer/Lexer.c \
    LexicalAnalyzer/Token.c \
    LexicalAnalyzer/Error.c \
    LexicalAnalyzer/Reader/Reader.c \
    LexicalAnalyzer/Reader/CodeLoc.c \
    -o "$EXECUTABLE"

echo "Running lexer..."

./"$EXECUTABLE" > "$OUTPUT_FILE" 2>&1

echo "Cleaning up..."

rm -f "$EXECUTABLE"

echo "Done."
echo "Output written to $OUTPUT_FILE"
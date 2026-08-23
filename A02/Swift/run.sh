#!/bin/bash
set -e
cd "$(dirname "$0")"

EXECUTABLE="lexer"
OUTPUT_DIR="Output"
OUTPUT_FILE="$OUTPUT_DIR/output.txt"

mkdir -p "$OUTPUT_DIR"
trap 'rm -f "$EXECUTABLE"' EXIT

swiftc \
    LexicalAnalyzer/main.swift \
    LexicalAnalyzer/Lexer.swift \
    LexicalAnalyzer/Token.swift \
    LexicalAnalyzer/Error.swift \
    LexicalAnalyzer/Reader/Reader.swift \
    LexicalAnalyzer/Reader/CodeLoc.swift \
    -o "$EXECUTABLE"

./"$EXECUTABLE" > "$OUTPUT_FILE" 2>&1

echo "Lexer test complete. Output written to $OUTPUT_FILE"

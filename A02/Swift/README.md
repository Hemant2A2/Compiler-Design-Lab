# C Lexical Analyzer — Swift Implementation

A lexical analyzer for the **C programming language**, implemented entirely in **Swift**.

The project reads a C source file character-by-character, recognizes C tokens, tracks line/column locations, and reports lexical errors without terminating at the first error.

## Architecture

```text
C Source File
      |
      v
   Reader
      |
      v
    Lexer
   /     \
  v       v
Tokens   Lexical Errors
```

The lexer is intentionally separate from the parser: lexical errors are detected here, while grammar-level syntax errors belong to the parser stage that can be added later.

## Project Structure

```text
A02/
├── Input/
│   └── input.c
├── Output/
│   └── output.txt
├── LexicalAnalyzer/
│   ├── main.swift
│   ├── Lexer.swift
│   ├── Token.swift
│   ├── Error.swift
│   └── Reader/
│       ├── Reader.swift
│       └── CodeLoc.swift
└── run.sh
```

### `Reader/CodeLoc.swift`
Defines `CodeLoc`, which stores a source position:

- `line`
- `column`

Every token and error stores this information so diagnostics can identify the exact source location.

### `Reader/Reader.swift`
Provides character-level input to the lexer.

Main responsibilities:

- Open and read the source file.
- Maintain the current character.
- Advance through the file.
- Track line and column numbers.
- Provide one-character lookahead.
- Detect EOF.
- Skip to the next source line for `//` comments.

Important functions:

- `init(filePath:)`
- `getChar()`
- `getCodeLoc()`
- `peek(_:)`
- `nextChar()`
- `nextLine()`
- `isEOF()`

### `Token.swift`
Defines the lexical vocabulary of the C lexer.

`TokenType` includes:

- punctuation: `(`, `)`, `{`, `}`, `[`, `]`, `,`, `;`
- arithmetic operators: `+`, `-`, `*`, `/`, `%`
- comparison/logical operators
- bitwise operators
- assignment operators
- shift operators
- `->`, `?`, `:`, `...`, `#`
- identifiers
- integer, floating-point, character and string literals
- C keywords
- comments, EOF and invalid tokens

`Token` stores:

- `type`
- `lexeme`
- `codeLoc`

The `cKeywords` dictionary maps C keyword strings to their token types, which allows the lexer to distinguish keywords from identifiers.

### `Error.swift`
Defines lexer errors and their formatted representation.

`ErrorType` currently supports:

- `lexical`
- `syntax` (reserved for the future parser)

`LexerError` stores:

- error type
- start location
- end location
- message

`formatted()` produces human-readable diagnostics.

### `Lexer.swift`
Contains the complete lexical-analysis implementation.

Major responsibilities:

- Scan the entire source file.
- Skip whitespace.
- Recognize identifiers and keywords.
- Recognize integer and floating-point literals.
- Recognize character and string literals.
- Distinguish one-character and multi-character operators.
- Handle `//` and `/* ... */` comments.
- Store tokens in an array.
- Collect lexical errors and continue scanning.

Important public functions/properties:

- `init(filePath:)`
- `getToken()`
- `peekToken(ahead:)`
- `advance()`
- `backward()`
- `nextToken()`
- `getCodeLoc()`
- `isEOF()`
- `expect(_:)`
- `printTokens()`
- `printErrors()`

Internal scanning helpers include:

- `consumeIdentifierOrKeyword()`
- `consumeNumber()`
- `consumeCharacterLiteral()`
- `consumeStringLiteral()`
- operator-specific consumers for `+`, `-`, `*`, `/`, `%`, `!`, `=`, `<`, `>`, `&`, `|`, and `^`

### `main.swift`
A small test driver.

It:

1. Creates a `Lexer` for `Input/input.c`.
2. Prints the generated token stream.
3. Prints collected lexical errors.
4. Writes the same complete report to `Output/output.txt`.

### `Input/input.c`
Test C source code used to exercise the lexer.

### `Output/output.txt`
Generated output from the latest lexer run.

### `run.sh`
Build-and-test script.

It:

1. Moves to the A02 directory.
2. Compiles all Swift source files with `swiftc`.
3. Runs the lexer.
4. Stores the output in `Output/output.txt`.
5. Removes the temporary executable even when the script exits unexpectedly.

## Running the Project

From the `A02` directory:

```bash
chmod +x run.sh
./run.sh
```

A successful run prints:

```text
Lexer test complete. Output written to Output/output.txt
```

The executable is temporary and is removed automatically.

## Manual Build

The same build can be performed manually with:

```bash
swiftc \
    LexicalAnalyzer/main.swift \
    LexicalAnalyzer/Lexer.swift \
    LexicalAnalyzer/Token.swift \
    LexicalAnalyzer/Error.swift \
    LexicalAnalyzer/Reader/Reader.swift \
    LexicalAnalyzer/Reader/CodeLoc.swift \
    -o lexer
```

Then:

```bash
./lexer
```

## Lexical Error Handling

The lexer records errors rather than stopping at the first invalid character.

For example:

```c
int x = 10 @ 5;
```

can produce:

```text
Lexical Error at line 1, column 11: Invalid character '@'
```

Malformed numbers such as:

```c
float x = 12.3.4;
```

are also detected.

The lexer can additionally report unterminated character literals, string literals, and block comments.

## Keywords vs Identifiers

The lexer first scans an identifier-shaped sequence. It then performs a keyword lookup.

For example:

```text
int       -> TYPE_INTEGER
const     -> CONST
return    -> RETURN
while     -> WHILE
myValue   -> IDENTIFIER
```

Thus, C keywords are never incorrectly treated as ordinary identifiers.

## Operator Recognition

Operators that share a prefix use lookahead. For example:

```text
=   -> ASSIGN
==  -> EQUAL
!   -> NOT
!=  -> NOT_EQUAL
<   -> LESS
<=  -> LESS_EQUAL
>   -> GREATER
>=  -> GREATER_EQUAL
+   -> PLUS
++  -> INCREMENT
+=  -> PLUS_ASSIGN
```

The same approach is used for shifts, compound assignments, logical operators, `->`, and other multi-character C operators.

## Lexer vs Parser

This project is a **lexer**, not yet a complete C compiler frontend.

A lexical error means the character sequence itself is invalid for the lexer. A syntax error means the generated tokens are valid individually but appear in an invalid order according to the C grammar.

For example:

```c
int const = 10;
```

The lexer correctly recognizes `const` as a C keyword. Determining that `const` cannot be used as the declarator name in that position is a parser responsibility.

## Requirements

- Swift 6.x or a compatible Swift toolchain
- `swiftc`

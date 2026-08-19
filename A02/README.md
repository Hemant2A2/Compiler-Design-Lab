## Project Structure

``` text
A02/
│
├── Input/
│   └── input.c
│
├── Output/
│   └── output.txt
│
├── LexicalAnalyzer/
│   │
│   ├── main.c
│   ├── Lexer.c
│   ├── Lexer.h
│   ├── Token.c
│   ├── Token.h
│   ├── Error.c
│   ├── Error.h
│   │
│   └── Reader/
│       ├── Reader.c
│       ├── Reader.h
│       ├── CodeLoc.c
│       └── CodeLoc.h
│
└── run.sh
```

------------------------------------------------------------------------

## File Overview

| File                | Purpose                                                   |
| ------------------- | --------------------------------------------------------- |
| `main.c`            | Entry point used to run and test the lexer                |
| `Lexer.h`           | Public interface and data structure for the lexer         |
| `Lexer.c`           | Core lexical-analysis implementation                      |
| `Token.h`           | Defines token types and the `Token` structure             |
| `Token.c`           | Token creation and token-type utilities                   |
| `Error.h`           | Defines the error representation                          |
| `Error.c`           | Error formatting, printing, and cleanup                   |
| `Reader.h`          | Public interface for source-file reading                  |
| `Reader.c`          | Reads characters and tracks source position               |
| `CodeLoc.h`         | Defines source line/column information                    |
| `CodeLoc.c`         | Utilities related to `CodeLoc`                            |
| `Input/input.c`     | C source file used as lexer input                         |
| `Output/output.txt` | Captures the result of a lexer run                        |
| `run.sh`            | Compiles, executes, and cleans up the lexer automatically |

------------------------------------------------------------------------

# 1. `Reader`

The Reader is the lowest-level component of the lexer.

Its responsibility is to provide the lexer with one character at a time
while keeping track of where that character occurs in the source file.

``` text
Source file
    │
    ▼
 Reader
    │
    ├── current character
    ├── current line
    └── current column
```

## `Reader.h`

Defines:

``` c
struct Reader
```

The structure stores:

-   `FILE *file` --- opened input file
-   `int currChar` --- current character
-   `struct CodeLoc currCodeLoc` --- current line and column

### Functions

#### `Reader_init()`

``` c
int Reader_init(
    struct Reader *reader,
    const char *filePath
);
```

Initializes a reader and opens the specified source file.

Returns:

-   `0` on success
-   non-zero on failure

#### `Reader_destroy()`

``` c
void Reader_destroy(
    struct Reader *reader
);
```

Closes the source file and releases Reader resources.

#### `Reader_getChar()`

``` c
char Reader_getChar(
    const struct Reader *reader
);
```

Returns the current character.

#### `Reader_getCodeLoc()`

``` c
struct CodeLoc Reader_getCodeLoc(
    const struct Reader *reader
);
```

Returns the current line and column.

#### `Reader_nextChar()`

``` c
void Reader_nextChar(
    struct Reader *reader
);
```

Moves the reader to the next character.

It also updates line/column information.

#### `Reader_nextLine()`

``` c
void Reader_nextLine(
    struct Reader *reader
);
```

Skips the remainder of the current line and moves to the next line.

This is particularly useful for handling `//` comments.

#### `Reader_isEOF()`

``` c
int Reader_isEOF(
    const struct Reader *reader
);
```

Checks whether the end of the input file has been reached.

------------------------------------------------------------------------

# 2. `CodeLoc`

`CodeLoc` represents the position of something in the source file.

## `CodeLoc.h`

Defines:

``` c
struct CodeLoc {
    unsigned int line;
    unsigned int column;
};
```

For example:

``` text
int value = 10;
    ^
    column 5
```

A token can therefore store:

``` text
line   = 1
column = 5
```

This information is essential for useful compiler diagnostics.

## `CodeLoc.c`

Contains utility functionality associated with `CodeLoc`, including
converting a source location into a printable representation.

------------------------------------------------------------------------

# 3. `Token`

The Token module defines the vocabulary produced by the lexer.

A token contains:

``` c
struct Token {
    enum TokenType type;
    const char *lexeme;
    struct CodeLoc codeLoc;
};
```

For example:

``` c
int value = 10;
```

can become:

``` text
TYPE_INTEGER   "int"
IDENTIFIER     "value"
ASSIGN         "="
INTEGER_LIT    "10"
SEMICOLON      ";"
```

Each token also contains its source location.

## `Token.h`

Defines the `TokenType` enumeration.

The token categories include:

### Punctuation

``` text
OPEN_PAREN
CLOSE_PAREN
OPEN_BRACE
CLOSE_BRACE
OPEN_BRACKET
CLOSE_BRACKET
COMMA
SEMICOLON
```

### Arithmetic operators

``` text
PLUS
MINUS
MUL
DIV
MOD
```

### Comparison and logical operators

``` text
NOT
NOT_EQUAL
ASSIGN
EQUAL
GREATER
GREATER_EQUAL
LESS
LESS_EQUAL
```

### Identifiers and literals

``` text
IDENTIFIER
INTEGER_LIT
FLOAT_LIT
```

### C keywords

The lexer can distinguish C keywords from user-defined identifiers.

Examples include:

``` text
int
float
void
const
return
if
else
for
while
case
break
continue
```

### Special token types

``` text
COMMENT
END_OF_FILE
INVALID
```

## `Token.c`

Responsible for token-related operations.

### `Token_create()`

Creates a Token with a specified type.

### `Token_create_with_lexeme()`

Creates a token with:

-   token type
-   lexeme
-   source location

### `TokenType_toString()`

Converts a token type into a human-readable string.

For example:

``` c
TokenType_toString(TYPE_INTEGER)
```

returns:

``` text
TYPE_INTEGER
```

This keeps token-name formatting out of `main.c` and the core lexer
logic.

------------------------------------------------------------------------

# 4. `Error`

The Error module provides a common representation for lexer and future
parser errors.

An error contains:

``` c
struct Error {
    enum ErrorType type;
    struct CodeLoc start;
    struct CodeLoc end;
    char *message;
};
```

The two primary error categories are:

``` text
ERROR_LEXICAL
ERROR_SYNTAX
```

## `Error.c`

### `Error_print()`

Prints an error in a readable format.

Example:

``` text
Lexical Error at line 6, column 12:
Invalid character '@'
```

### `Error_destroy()`

Releases dynamically allocated error-message memory.

------------------------------------------------------------------------

# 5. `Lexer`

The Lexer is the main component of the project.

It consumes characters from the Reader and converts them into tokens.

``` text
Reader
  │
  │ characters
  ▼
Lexer
  │
  ├── keywords
  ├── identifiers
  ├── numbers
  ├── operators
  ├── punctuation
  ├── comments
  └── invalid input
       │
       ▼
     Tokens
```

## `Lexer.h`

Defines:

``` c
struct Lexer
```

The Lexer stores:

-   `Reader reader` --- source-file reader
-   `currTokIndex` --- current position in the token stream
-   `currToken` --- temporary token currently being consumed
-   `tokens` --- dynamically allocated token array
-   `tokenCount` --- number of tokens
-   `tokenCapacity` --- allocated token capacity
-   `errors` --- dynamically allocated error array
-   `errorCount` --- number of errors
-   `errorCapacity` --- allocated error capacity

### `Lexer_init()`

``` c
int Lexer_init(
    struct Lexer *lexer,
    const char *filePath
);
```

Initializes the lexer and reads the source file.

The current implementation tokenizes the input during initialization.

### `Lexer_destroy()`

Releases:

-   token memory
-   error memory
-   reader resources
-   dynamically allocated lexemes

### `Lexer_getToken()`

Returns the current token.

### `Lexer_peekToken()`

``` c
Lexer_peekToken(lexer, ahead)
```

Looks ahead in the token stream without changing the current position.

### `Lexer_advance()`

Consumes the next lexical token.

It also:

-   skips whitespace
-   detects comments
-   stores valid tokens
-   records lexical errors

### `Lexer_backward()`

Moves one position backwards in the token stream.

### `Lexer_nextToken()`

Moves to the next token.

### `Lexer_getCodeLoc()`

Returns the current source location from the Reader.

### `Lexer_isEOF()`

Checks whether the Reader has reached the end of the file.

### `Lexer_expect()`

Checks whether the current token has the expected token type.

This function is particularly useful when the parser is implemented.

### `Lexer_printTokens()`

Prints all generated tokens.

Example:

``` text
Token: TYPE_INTEGER | Lexeme: int | Line: 1 | Column: 1
Token: IDENTIFIER   | Lexeme: main | Line: 1 | Column: 5
Token: OPEN_PAREN   | Lexeme: (   | Line: 1 | Column: 9
```

### `Lexer_printErrors()`

Prints all lexical errors collected during lexing.

The Lexer stores errors instead of immediately terminating, allowing
multiple errors to be reported from one source file.

------------------------------------------------------------------------

# 6. Lexical Analysis

The lexer currently recognizes several important classes of C tokens.

## Identifiers

Examples:

``` c
variable
counter
main
value123
_myVariable
```

Identifiers that are not C keywords are classified as:

``` text
IDENTIFIER
```

## Keywords

C keywords are recognized separately.

For example:

``` c
int
return
while
const
```

are not classified as `IDENTIFIER`.

Instead:

``` text
int     → TYPE_INTEGER
return  → RETURN
while   → WHILE
const   → CONST
```

This distinction is important for the parser.

## Integer literals

Examples:

``` c
0
10
12345
```

are classified as:

``` text
INTEGER_LIT
```

## Floating-point literals

Examples:

``` c
1.5
15.25
3.14159
```

are classified as:

``` text
FLOAT_LIT
```

Malformed floating-point values such as:

``` c
15.5.2
```

can be reported as lexical errors.

## Operators

The lexer recognizes supported operators such as:

``` text
+
-
*
/
%
!
!=
=
==
<
<=
>
>=
```

## Comments

Single-line C comments beginning with:

``` c
//
```

are recognized as `COMMENT` tokens internally and can be excluded from
the final token stream.

## Invalid characters

Characters that are not valid in the currently supported C lexical
grammar are reported as lexical errors.

For example:

``` c
int x = 10 @ 5;
```

can produce:

``` text
Lexical Error at line 1, column 12:
Invalid character '@'
```

------------------------------------------------------------------------

# 7. Error Handling

The lexer is designed to continue after recoverable lexical errors
instead of terminating at the first problem.

For example:

``` c
int x = 10 @ 5;
int y = 20 # 4;
```

can result in multiple diagnostics:

``` text
Lexical Error at line 1, column 12: Invalid character '@'
Lexical Error at line 2, column 12: Invalid character '#'
```

This is useful because the user can fix several problems in one
compilation attempt.

------------------------------------------------------------------------

# 8. `main.c`

`main.c` is intentionally kept small.

Its job is to:

1.  Initialize the lexer.
2.  Pass `Input/input.c` to the lexer.
3.  Print generated tokens.
4.  Print lexical errors.
5.  Destroy the lexer.

Typical usage:

``` c
int main(void) {
    struct Lexer lexer;

    if (Lexer_init(&lexer, "Input/input.c") != 0) {
        return 1;
    }

    Lexer_printTokens(&lexer);
    Lexer_printErrors(&lexer);

    Lexer_destroy(&lexer);

    return 0;
}
```

The token definitions and printing logic do **not** belong in `main.c`;
those responsibilities are handled by `Token.c` and `Lexer.c`.

------------------------------------------------------------------------

# 9. `Input/input.c`

This is the source program used to test the lexer.

It can contain:

-   declarations
-   identifiers
-   literals
-   operators
-   comments
-   control-flow statements
-   intentionally malformed input for error testing

Example:

``` c
int main() {
    int a = 10;
    int b = 20;
    float x = 15.5;

    if (a < b) {
        a = a + 5;
    }

    return 0;
}
```

------------------------------------------------------------------------

# 10. `Output/output.txt`

The output file contains the result of running the lexer.

It includes:

-   generated tokens
-   token lexemes
-   token source locations
-   lexical error messages

This provides an easy way to inspect and verify lexer behavior.

------------------------------------------------------------------------

# 11. `run.sh`

`run.sh` automates the complete test process.

It:

1.  Moves to the project root.
2.  Creates the `Output` directory if necessary.
3.  Compiles the lexer.
4.  Runs the lexer against `Input/input.c`.
5.  Redirects both standard output and error output to
    `Output/output.txt`.
6.  Removes the temporary executable when finished.

Run it with:

``` bash
./run.sh
```

If necessary, make it executable once:

``` bash
chmod +x run.sh
```

The executable generated during compilation is intentionally removed
after execution so the repository remains clean.

------------------------------------------------------------------------

#include "Lexer.h"

#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

/*
 * Initialize Lexer.
 */
int Lexer_init(
    struct Lexer *lexer,
    const char *filePath
) {
    lexer->currTokIndex = 0;

    lexer->tokens = NULL;
    lexer->tokenCount = 0;
    lexer->tokenCapacity = 0;

    lexer->errors = NULL;
    lexer->errorCount = 0;
    lexer->errorCapacity = 0;

    lexer->currToken = Token_create(INVALID);

    if (Reader_init(&lexer->reader, filePath) != 0) {
        return 1;
    }

    Lexer_advance(lexer);

    while (lexer->currToken.type != END_OF_FILE) {
        Lexer_advance(lexer);
    }

    return 0;
}

/*
 * Duplicate a C string.
 */
static char *Lexer_strdup(const char *str) {
    size_t len = strlen(str);

    char *copy = malloc(len + 1);

    if (copy == NULL) {
        return NULL;
    }

    memcpy(copy, str, len + 1);

    return copy;
}


/*
 * Create a token whose lexeme is copied onto the heap.
 *
 * This is important because identifiers and numbers are generated
 * dynamically while lexing.
 */
static struct Token Lexer_makeToken(
    enum TokenType type,
    const char *lexeme,
    struct CodeLoc codeLoc
) {
    struct Token token;

    token.type = type;
    token.lexeme = Lexer_strdup(lexeme);
    token.codeLoc = codeLoc;

    return token;
}


/*
 * Add a token to the lexer's dynamic token array.
 */
static int Lexer_addToken(
    struct Lexer *lexer,
    struct Token token
) {
    if (lexer->tokenCount >= lexer->tokenCapacity) {

        size_t newCapacity;

        if (lexer->tokenCapacity == 0) {
            newCapacity = 16;
        } else {
            newCapacity = lexer->tokenCapacity * 2;
        }

        struct Token *newTokens = realloc(
            lexer->tokens,
            newCapacity * sizeof(struct Token)
        );

        if (newTokens == NULL) {
            return 1;
        }

        lexer->tokens = newTokens;
        lexer->tokenCapacity = newCapacity;
    }

    lexer->tokens[lexer->tokenCount] = token;
    lexer->tokenCount++;

    return 0;
}


/*
 * Consume an identifier or keyword.
 *
 * Examples:
 *
 *   hello
 *   variable123
 *   and
 *   while
 *   return
 */
static struct Token Lexer_consumeIdentifier(
    struct Lexer *lexer
) {
    char buffer[256];
    size_t length = 0;

    struct CodeLoc startLoc = Reader_getCodeLoc(&lexer->reader);

    while (!Reader_isEOF(&lexer->reader)) {

        int c = Reader_getChar(&lexer->reader);

        if (!isalnum((unsigned char)c) && c != '_') {
            break;
        }

        if (length < sizeof(buffer) - 1) {
            buffer[length++] = (char)c;
        }

        Reader_nextChar(&lexer->reader);
    }

    buffer[length] = '\0';

    enum TokenType type = IDENTIFIER;

    if (strcmp(buffer, "and") == 0) {
        type = AND;
    }
    else if (strcmp(buffer, "or") == 0) {
        type = OR;
    }
    else if (strcmp(buffer, "if") == 0) {
        type = IF;
    }
    else if (strcmp(buffer, "else") == 0) {
        type = ELSE;
    }
    else if (strcmp(buffer, "for") == 0) {
        type = FOR;
    }
    else if (strcmp(buffer, "while") == 0) {
        type = WHILE;
    }
    else if (strcmp(buffer, "return") == 0) {
        type = RETURN;
    }
    else if (strcmp(buffer, "true") == 0) {
        type = TRUE;
    }
    else if (strcmp(buffer, "false") == 0) {
        type = FALSE;
    }
    else if (strcmp(buffer, "int") == 0) {
        type = TYPE_INTEGER;
    }
    else if (strcmp(buffer, "float") == 0) {
        type = TYPE_FLOAT;
    } 
    else if (strcmp(buffer, "break") == 0) {
        type = BREAK;
    }
    else if (strcmp(buffer, "case") == 0) {
        type = CASE;
    }
    else if (strcmp(buffer, "const") == 0) {
        type = CONST;
    }
    else if (strcmp(buffer, "continue") == 0) {
        type = CONTINUE;
    }
    else if (strcmp(buffer, "default") == 0) {
        type = DEFAULT;
    }
    else if (strcmp(buffer, "do") == 0) {
        type = DO;
    }

    return Lexer_makeToken(
        type,
        buffer,
        startLoc
    );
}


/*
 * Consume an integer or floating-point literal.
 *
 * Examples:
 *
 *   123
 *   42.5
 *   3.14159
 */
static struct Token Lexer_consumeNumber(
    struct Lexer *lexer
) {
    char buffer[256];
    size_t length = 0;

    struct CodeLoc startLoc =
        Reader_getCodeLoc(&lexer->reader);

    /*
     * Consume the integer part.
     */
    while (!Reader_isEOF(&lexer->reader)) {

        int c = Reader_getChar(&lexer->reader);

        if (!isdigit((unsigned char)c)) {
            break;
        }

        if (length < sizeof(buffer) - 1) {
            buffer[length++] = (char)c;
        }

        Reader_nextChar(&lexer->reader);
    }

    /*
     * Check whether this is a floating-point literal.
     */
    if (!Reader_isEOF(&lexer->reader) &&
        Reader_getChar(&lexer->reader) == '.') {

        /*
         * Consume the decimal point.
         */
        if (length < sizeof(buffer) - 1) {
            buffer[length++] = '.';
        }

        Reader_nextChar(&lexer->reader);

        /*
         * There must be at least one digit after
         * the decimal point for our current lexer.
         */
        if (Reader_isEOF(&lexer->reader) ||
            !isdigit(
                (unsigned char)Reader_getChar(
                    &lexer->reader
                )
            )) {

            struct CodeLoc errorLoc =
                Reader_getCodeLoc(&lexer->reader);

            Lexer_addError(
                lexer,
                ERROR_LEXICAL,
                errorLoc,
                errorLoc,
                "Invalid floating-point literal: expected digit after '.'"
            );
        }

        /*
         * Consume fractional part.
         */
        while (!Reader_isEOF(&lexer->reader)) {

            int c = Reader_getChar(&lexer->reader);

            if (!isdigit((unsigned char)c)) {
                break;
            }

            if (length < sizeof(buffer) - 1) {
                buffer[length++] = (char)c;
            }

            Reader_nextChar(&lexer->reader);
        }

        /*
         * If another '.' follows, THEN it really is
         * an invalid numeric literal.
         */
        if (!Reader_isEOF(&lexer->reader) &&
            Reader_getChar(&lexer->reader) == '.') {

            struct CodeLoc errorLoc =
                Reader_getCodeLoc(&lexer->reader);

            Lexer_addError(
                lexer,
                ERROR_LEXICAL,
                errorLoc,
                errorLoc,
                "Invalid numeric literal: multiple decimal points"
            );

            /*
             * Consume the rest of the malformed number.
             */
            while (!Reader_isEOF(&lexer->reader)) {

                int c =
                    Reader_getChar(&lexer->reader);

                if (!isdigit((unsigned char)c) &&
                    c != '.') {
                    break;
                }

                Reader_nextChar(&lexer->reader);
            }
        }

        buffer[length] = '\0';

        return Lexer_makeToken(
            FLOAT_LIT,
            buffer,
            startLoc
        );
    }

    /*
     * Integer literal.
     */
    buffer[length] = '\0';

    return Lexer_makeToken(
        INTEGER_LIT,
        buffer,
        startLoc
    );
}


/*
 * Consume one token.
 */
static struct Token Lexer_consumeToken(
    struct Lexer *lexer
) {
    int currChar = Reader_getChar(&lexer->reader);

    /*
     * EOF
     */
    if (Reader_isEOF(&lexer->reader)) {
        return Lexer_makeToken(
            END_OF_FILE,
            "EOF",
            Reader_getCodeLoc(&lexer->reader)
        );
    }


    /*
     * Identifier / keyword
     */
    if (isalpha((unsigned char)currChar) ||
        currChar == '_') {

        return Lexer_consumeIdentifier(lexer);
    }


    /*
     * Number
     */
    if (isdigit((unsigned char)currChar)) {
        return Lexer_consumeNumber(lexer);
    }


    /*
     * Save location before consuming the character.
     */
    struct CodeLoc loc =
        Reader_getCodeLoc(&lexer->reader);


    /*
     * Consume current character.
     */
    Reader_nextChar(&lexer->reader);


    switch (currChar) {

        case '(':
            return Lexer_makeToken(
                OPEN_PAREN,
                "(",
                loc
            );

        case ')':
            return Lexer_makeToken(
                CLOSE_PAREN,
                ")",
                loc
            );

        case '{':
            return Lexer_makeToken(
                OPEN_BRACE,
                "{",
                loc
            );

        case '}':
            return Lexer_makeToken(
                CLOSE_BRACE,
                "}",
                loc
            );

        case '[':
            return Lexer_makeToken(
                OPEN_BRACKET,
                "[",
                loc
            );

        case ']':
            return Lexer_makeToken(
                CLOSE_BRACKET,
                "]",
                loc
            );

        case ',':
            return Lexer_makeToken(
                COMMA,
                ",",
                loc
            );

        case ';':
            return Lexer_makeToken(
                SEMICOLON,
                ";",
                loc
            );

        case '-':
            return Lexer_makeToken(
                MINUS,
                "-",
                loc
            );

        case '+':
            return Lexer_makeToken(
                PLUS,
                "+",
                loc
            );

        case '*':
            return Lexer_makeToken(
                MUL,
                "*",
                loc
            );

        case '%':
            return Lexer_makeToken(
                MOD,
                "%",
                loc
            );


        /*
         * /
         *
         * Could be DIV or COMMENT.
         */
        case '/':

            if (!Reader_isEOF(&lexer->reader) &&
                Reader_getChar(&lexer->reader) == '/') {

                struct CodeLoc commentLoc = loc;

                Reader_nextLine(&lexer->reader);

                return Lexer_makeToken(
                    COMMENT,
                    "//",
                    commentLoc
                );
            }

            return Lexer_makeToken(
                DIV,
                "/",
                loc
            );


        /*
         * !
         *
         * Could be NOT or NOT_EQUAL.
         */
        case '!': {

            if (!Reader_isEOF(&lexer->reader) &&
                Reader_getChar(&lexer->reader) == '=') {

                Reader_nextChar(&lexer->reader);

                return Lexer_makeToken(
                    NOT_EQUAL,
                    "!=",
                    loc
                );
            }

            return Lexer_makeToken(
                NOT,
                "!",
                loc
            );
        }


        /*
         * =
         *
         * Could be ASSIGN or EQUAL.
         */
        case '=': {

            if (!Reader_isEOF(&lexer->reader) &&
                Reader_getChar(&lexer->reader) == '=') {

                Reader_nextChar(&lexer->reader);

                return Lexer_makeToken(
                    EQUAL,
                    "==",
                    loc
                );
            }

            return Lexer_makeToken(
                ASSIGN,
                "=",
                loc
            );
        }


        /*
         * >
         *
         * Only GREATER and GREATER_EQUAL exist
         * in your Token.h.
         */
        case '>': {

            if (!Reader_isEOF(&lexer->reader) &&
                Reader_getChar(&lexer->reader) == '=') {

                Reader_nextChar(&lexer->reader);

                return Lexer_makeToken(
                    GREATER_EQUAL,
                    ">=",
                    loc
                );
            }

            return Lexer_makeToken(
                GREATER,
                ">",
                loc
            );
        }


        /*
         * <
         *
         * Only LESS and LESS_EQUAL exist
         * in your Token.h.
         */
        case '<': {

            if (!Reader_isEOF(&lexer->reader) &&
                Reader_getChar(&lexer->reader) == '=') {

                Reader_nextChar(&lexer->reader);

                return Lexer_makeToken(
                    LESS_EQUAL,
                    "<=",
                    loc
                );
            }

            return Lexer_makeToken(
                LESS,
                "<",
                loc
            );
        }


        default: {

            /*
             * Unknown character.
             */
            char invalid[2];

            invalid[0] = (char)currChar;
            invalid[1] = '\0';

            char message[128];

            snprintf(
                message,
                sizeof(message),
                "Invalid character '%c'",
                currChar
            );

            Lexer_addError(
                  lexer,
                  ERROR_LEXICAL,
                  loc,
                  loc,
                  message
              );

            return Lexer_makeToken(
                INVALID,
                invalid,
                loc
            );
        }
    }
}


/*
 * Destroy Lexer.
 */
void Lexer_destroy(struct Lexer *lexer) {

    for (size_t i = 0;
         i < lexer->tokenCount;
         ++i) {

        free((void *)lexer->tokens[i].lexeme);
    }

    free(lexer->tokens);

    for (size_t i = 0;
         i < lexer->errorCount;
         ++i) {

        Error_destroy(&lexer->errors[i]);
    }

    free(lexer->errors);

    free((void *)lexer->currToken.lexeme);

    Reader_destroy(&lexer->reader);

    lexer->tokens = NULL;
    lexer->errors = NULL;
}


/*
 * Get current token.
 */
const struct Token *Lexer_getToken(
    const struct Lexer *lexer
) {
    if (lexer->tokenCount == 0) {
        return NULL;
    }

    if (lexer->currTokIndex >= lexer->tokenCount) {
        return &lexer->tokens[lexer->tokenCount - 1];
    }

    return &lexer->tokens[lexer->currTokIndex];
}


/*
 * Peek ahead.
 */
const struct Token *Lexer_peekToken(
    const struct Lexer *lexer,
    size_t ahead
) {
    if (lexer->tokenCount == 0) {
        return NULL;
    }

    if (lexer->currTokIndex + ahead >= lexer->tokenCount) {
        return &lexer->tokens[lexer->tokenCount - 1];
    }

    return &lexer->tokens[
        lexer->currTokIndex + ahead
    ];
}


/*
 * Advance lexer and create the next token.
 */
void Lexer_advance(struct Lexer *lexer) {

    /*
     * Skip whitespace.
     */
    while (!Reader_isEOF(&lexer->reader) &&
           isspace(
               (unsigned char)Reader_getChar(&lexer->reader)
           )) {

        Reader_nextChar(&lexer->reader);
    }


    /*
     * Free the previous temporary current token.
     */
    free((void *)lexer->currToken.lexeme);


    /*
     * Consume next token.
     */
    lexer->currToken =
        Lexer_consumeToken(lexer);


    /*
     * Don't put comments into the token vector.
     */
    if (lexer->currToken.type != COMMENT) {

        /*
         * Add a copy of currToken to the vector.
         *
         * The lexeme ownership is transferred to the vector.
         */
        if (Lexer_addToken(
                lexer,
                lexer->currToken
            ) != 0) {

            fprintf(
                stderr,
                "Lexer error: failed to allocate token array\n"
            );

            exit(EXIT_FAILURE);
        }

        /*
         * Prevent currToken from being freed again.
         */
        lexer->currToken.lexeme = NULL;
    }
}


/*
 * Move one token backward.
 */
void Lexer_backward(struct Lexer *lexer) {

    if (lexer->currTokIndex == 0) {
        return;
    }

    lexer->currTokIndex--;
}


/*
 * Move one token forward.
 */
void Lexer_nextToken(struct Lexer *lexer) {

    if (lexer->currTokIndex + 1 <
        lexer->tokenCount) {

        lexer->currTokIndex++;
    }
}


/*
 * Is reader at EOF?
 */
int Lexer_isEOF(
    const struct Lexer *lexer
) {
    return Reader_isEOF(&lexer->reader);
}


/*
 * Get current source location.
 */
struct CodeLoc Lexer_getCodeLoc(
    const struct Lexer *lexer
) {
    return Reader_getCodeLoc(&lexer->reader);
}


/*
 * Expect a particular token.
 */
void Lexer_expect(
    struct Lexer *lexer,
    enum TokenType expectedType
) {
    const struct Token *token =
        Lexer_getToken(lexer);

    if (token == NULL) {
        fprintf(
            stderr,
            "Lexer::expect() failed: no current token\n"
        );

        assert(0);
        return;
    }

    if (token->type != expectedType) {

        fprintf(
            stderr,
            "Lexer_expect() failed: "
            "Expected token type %d but got token type %d "
            "with lexeme '%s' at line %u, column %u\n",

            expectedType,
            token->type,

            token->lexeme != NULL
                ? token->lexeme
                : "",

            token->codeLoc.line,
            token->codeLoc.column
        );
    }

    assert(token->type == expectedType);

    Lexer_nextToken(lexer);
}


/*
 * Print all tokens.
 */
void Lexer_printTokens(
    const struct Lexer *lexer
) {
    for (size_t i = 0;
         i < lexer->tokenCount;
         ++i) {

        const struct Token *token =
            &lexer->tokens[i];

        printf(
            "Token: %-16s | Lexeme: %-12s | Line: %u | Column: %u\n",

            TokenType_toString(token->type),

            token->lexeme != NULL
                ? token->lexeme
                : "",

            token->codeLoc.line,
            token->codeLoc.column
        );
    }
}

void Lexer_addError(
    struct Lexer *lexer,
    enum ErrorType type,
    struct CodeLoc start,
    struct CodeLoc end,
    const char *message
) {
    if (lexer->errorCount >= lexer->errorCapacity) {

        size_t newCapacity =
            lexer->errorCapacity == 0
                ? 8
                : lexer->errorCapacity * 2;

        struct Error *newErrors = realloc(
            lexer->errors,
            newCapacity * sizeof(struct Error)
        );

        if (newErrors == NULL) {
            fprintf(
                stderr,
                "Fatal error: could not allocate error list\n"
            );

            exit(EXIT_FAILURE);
        }

        lexer->errors = newErrors;
        lexer->errorCapacity = newCapacity;
    }

    struct Error *error =
        &lexer->errors[lexer->errorCount];

    error->type = type;
    error->start = start;
    error->end = end;

    error->message = malloc(strlen(message) + 1);

    if (error->message == NULL) {
        fprintf(
            stderr,
            "Fatal error: could not allocate error message\n"
        );

        exit(EXIT_FAILURE);
    }

    strcpy(error->message, message);

    lexer->errorCount++;
}

void Lexer_printErrors(
    const struct Lexer *lexer
) {
    if (lexer->errorCount == 0) {
        printf("No lexical errors found.\n");
        return;
    }

    for (size_t i = 0;
         i < lexer->errorCount;
         ++i) {

        Error_print(&lexer->errors[i]);
    }
}
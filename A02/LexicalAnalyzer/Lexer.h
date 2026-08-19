#pragma once

#include <stddef.h>

#include "Token.h"
#include "Error.h"
#include "Reader/Reader.h"

struct Lexer {
    struct Reader reader;

    size_t currTokIndex;
    struct Token currToken;

    struct Token *tokens;
    size_t tokenCount;
    size_t tokenCapacity;

    struct Error *errors;
    size_t errorCount;
    size_t errorCapacity;
};

/* Init the lexer -> Returns 0 on success, non-zero on failure. */
int Lexer_init(struct Lexer *lexer, const char *filePath);

/* Free all memory owned by the lexer. */
void Lexer_destroy(struct Lexer *lexer);

const struct Token *Lexer_getToken(const struct Lexer *lexer);

const struct Token *Lexer_peekToken(
    const struct Lexer *lexer,
    size_t ahead
);

void Lexer_advance(struct Lexer *lexer);

void Lexer_backward(struct Lexer *lexer);

void Lexer_nextToken(struct Lexer *lexer);

struct CodeLoc Lexer_getCodeLoc(const struct Lexer *lexer);

int Lexer_isEOF(const struct Lexer *lexer);

void Lexer_expect(
    struct Lexer *lexer,
    enum TokenType expectedType
);

void Lexer_printTokens(const struct Lexer *lexer);

void Lexer_addError (
    struct Lexer *lexer,
    enum ErrorType type,
    struct CodeLoc start,
    struct CodeLoc end,
    const char *message
);

void Lexer_printErrors(const struct Lexer *lexer);
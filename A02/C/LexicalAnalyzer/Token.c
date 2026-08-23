#include "Token.h"
#include <stddef.h>

struct Token Token_create(enum TokenType type) {
    struct Token token;

    token.type = type;
    token.lexeme = NULL;
    token.codeLoc.line = 0;
    token.codeLoc.column = 0;

    return token;
}

struct Token Token_create_with_lexeme(
    enum TokenType type,
    const char *lexeme,
    struct CodeLoc codeLoc
) {
    struct Token token;

    token.type = type;
    token.lexeme = lexeme;
    token.codeLoc = codeLoc;

    return token;
}

static const char *tokenTypeNames[] = {
    "OPEN_PAREN",
    "CLOSE_PAREN",
    "OPEN_BRACE",
    "CLOSE_BRACE",
    "OPEN_BRACKET",
    "CLOSE_BRACKET",
    "COMMA",
    "SEMICOLON",
    "MINUS",
    "PLUS",
    "DIV",
    "MUL",
    "MOD",
    "NOT",
    "NOT_EQUAL",
    "ASSIGN",
    "EQUAL",
    "GREATER",
    "GREATER_EQUAL",
    "LESS",
    "LESS_EQUAL",
    "IDENTIFIER",
    "INTEGER_LIT",
    "FLOAT_LIT",
    "TYPE_INTEGER",
    "TYPE_FLOAT",
    "AND",
    "ELSE",
    "FALSE",
    "FOR",
    "IF",
    "OR",
    "RETURN",
    "TRUE",
    "WHILE",
    "BREAK",
    "CASE",
    "CONST",
    "CONTINUE",
    "DEFAULT",
    "DO",
    "COMMENT",
    "END_OF_FILE",
    "INVALID"
};

const char *TokenType_toString(enum TokenType type) {
    if (type < 0 || type > INVALID) {
        return "UNKNOWN";
    }

    return tokenTypeNames[type];
}
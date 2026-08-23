#pragma once

#include "Reader/CodeLoc.h"

enum ErrorType {
    ERROR_LEXICAL,
    ERROR_SYNTAX
};

struct Error {
    enum ErrorType type;
    struct CodeLoc start;
    struct CodeLoc end;
    char *message;
};

void Error_print(const struct Error *error);

void Error_destroy(struct Error *error);
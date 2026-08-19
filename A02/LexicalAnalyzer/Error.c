#include "Error.h"

#include <stdio.h>
#include <stdlib.h>

void Error_print(const struct Error *error) {
    const char *type;

    if (error->type == ERROR_LEXICAL) {
        type = "Lexical Error";
    } else {
        type = "Syntax Error";
    }

    if (error->start.line == error->end.line &&
        error->start.column == error->end.column) {

        fprintf(
            stderr,
            "%s at line %u, column %u: %s\n",
            type,
            error->start.line,
            error->start.column,
            error->message
        );

    } else {

        fprintf(
            stderr,
            "%s at line %u, column %u to line %u, column %u: %s\n",
            type,
            error->start.line,
            error->start.column,
            error->end.line,
            error->end.column,
            error->message
        );
    }
}

void Error_destroy(struct Error *error) {
    if (error == NULL) {
        return;
    }

    free(error->message);
}
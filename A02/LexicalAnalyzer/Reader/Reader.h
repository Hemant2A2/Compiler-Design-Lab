#pragma once

#include <stdio.h>

#include "CodeLoc.h"

struct Reader {
    FILE *file;
    int currChar;
    struct CodeLoc currCodeLoc;
};

/* Init a Reader -> Returns 0 on success, non-zero on failure. */
int Reader_init(struct Reader *reader, const char *filePath);

/* Close file and clean up the Reader. */
void Reader_destroy(struct Reader *reader);

char Reader_getChar(const struct Reader *reader);

struct CodeLoc Reader_getCodeLoc(const struct Reader *reader);

void Reader_nextChar(struct Reader *reader);

void Reader_nextLine(struct Reader *reader);

int Reader_isEOF(const struct Reader *reader);
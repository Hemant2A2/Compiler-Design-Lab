#include "Reader.h"

int Reader_init(struct Reader *reader, const char *filePath) {
    reader->file = fopen(filePath, "r");

    if (reader->file == NULL) {
        return 1;
    }

    reader->currChar = '\0';
    reader->currCodeLoc.line = 1;
    reader->currCodeLoc.column = 0;

    Reader_nextChar(reader);

    return 0;
}

void Reader_destroy(struct Reader *reader) {
    if (reader->file != NULL) {
        fclose(reader->file);
        reader->file = NULL;
    }
}

char Reader_getChar(const struct Reader *reader) {
    return (char)reader->currChar;
}

struct CodeLoc Reader_getCodeLoc(const struct Reader *reader) {
    return reader->currCodeLoc;
}

void Reader_nextChar(struct Reader *reader) {
    if (Reader_isEOF(reader)) {
        return;
    }

    if (reader->currChar == '\n') {
        reader->currCodeLoc.line++;
        reader->currCodeLoc.column = 0;
    }

    reader->currChar = fgetc(reader->file);
    reader->currCodeLoc.column++;
}

void Reader_nextLine(struct Reader *reader) {
    if (Reader_isEOF(reader)) {
        return;
    }

    reader->currCodeLoc.line++;
    reader->currCodeLoc.column = 0;

    int c;

    while ((c = fgetc(reader->file)) != '\n' && c != EOF) {
        /* Consume characters until newline or EOF. */
    }

    if (c == EOF) {
        reader->currChar = EOF;
        return;
    }

    reader->currChar = fgetc(reader->file);
    reader->currCodeLoc.column++;
}

int Reader_isEOF(const struct Reader *reader) {
    return reader->currChar == EOF;
}
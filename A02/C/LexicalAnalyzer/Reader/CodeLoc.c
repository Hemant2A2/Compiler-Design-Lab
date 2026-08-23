#include "CodeLoc.h"
#include <stdio.h>

#define MAX_BUFFER_SIZE 256

char *CodeLoc_print(const struct CodeLoc *loc) {
  static char buffer[MAX_BUFFER_SIZE];
  snprintf(buffer, sizeof(buffer), "Ln: %u, Col: %u", loc->line, loc->column);
  return buffer;
}
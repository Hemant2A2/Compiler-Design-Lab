#pragma once

struct CodeLoc {
  unsigned int line;
  unsigned int column;
};

char *CodeLoc_print(const struct CodeLoc *loc);
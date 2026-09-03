%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

// Symbol table node structure
typedef struct SymbolNode {
    char name[128];
    char type[64];
    int line_declared;
    struct SymbolNode* next;
} SymbolNode;

SymbolNode* symbolTable[TABLE_SIZE];

// Hash function
unsigned int hash(const char* str) {
    unsigned int hash = 0;
    while (*str) {
        hash = (hash << 5) + *str++;
    }
    return hash % TABLE_SIZE;
}

// Insert symbol into symbol table (avoid duplicate entries)
void insertSymbol(const char* name, const char* type, int line) {
    unsigned int idx = hash(name);
    SymbolNode* current = symbolTable[idx];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return;
        }
        current = current->next;
    }
    SymbolNode* newNode = (SymbolNode*)malloc(sizeof(SymbolNode));
    strcpy(newNode->name, name);
    strcpy(newNode->type, type);
    newNode->line_declared = line;
    newNode->next = symbolTable[idx];
    symbolTable[idx] = newNode;
}

// Print formatted Symbol Table
void printSymbolTable() {
    printf("\n======================== SYMBOL TABLE ========================\n");
    printf("%-24s | %-15s | %-15s\n", "Identifier Name", "Type", "Line Declared");
    printf("--------------------------------------------------------------\n");
    for (int i = 0; i < TABLE_SIZE; i++) {
        SymbolNode* curr = symbolTable[i];
        while (curr != NULL) {
            printf("%-24s | %-15s | %-15d\n", curr->name, curr->type, curr->line_declared);
            curr = curr->next;
        }
    }
    printf("==============================================================\n\n");
}

int line_num = 1;
%}

%option noyywrap

/* Regular Expression Definitions for Swift */
DIGIT           [0-9]
HEX_DIGIT       [0-9a-fA-F]
OCT_DIGIT       [0-7]
BIN_DIGIT       [0-1]
LETTER          [a-zA-Z_]

/* Swift supports underscores in numeric literals */
DEC_INT         {DIGIT}([0-9_]*{DIGIT})*
HEX_INT         0[xX]{HEX_DIGIT}([0-9a-fA-F_]*{HEX_DIGIT})*
OCT_INT         0[oO]{OCT_DIGIT}([0-7_]*{OCT_DIGIT})*
BIN_INT         0[bB]{BIN_DIGIT}([0-1_]*{BIN_DIGIT})*
INT_CONST       {HEX_INT}|{OCT_INT}|{BIN_INT}|{DEC_INT}

EXPONENT        ([eE][+-]?{DIGIT}+)
FLOAT_CONST     ({DEC_INT}\.{DIGIT}+({EXPONENT})?|{DEC_INT}{EXPONENT})

ESC_SEQ         \\([0\\tnr'\"]|u\{[0-9a-fA-F]{1,8}\})
CHAR_CONST      '([^'\\\n]|{ESC_SEQ})'
STRING_LITERAL  \"([^"\\\n]|{ESC_SEQ})*\"

IDENTIFIER      {LETTER}({LETTER}|{DIGIT})*

%%

\n                          { line_num++; }
[ \t\r\f\v]+                { /* Discard whitespace */ }

"//".*                      { /* Discard single-line comments */ }
"/\*"([^*]|\*+[^*/])*\*+"/" { 
    /* Discard multi-line comments and track lines */
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') line_num++;
    }
}

"#".*                       { printf("[Line %d] PREPROCESSOR_DIRECTIVE: %s\n", line_num, yytext); }

    /* Swift Keywords */
"associatedtype"|"class"|"deinit"|"enum"|"extension"|"fileprivate"|"func"|"import"|"init"|"inout"|"internal"|"let"|"open"|"operator"|"private"|"protocol"|"public"|"rethrows"|"static"|"struct"|"subscript"|"typealias"|"var"|"break"|"case"|"continue"|"default"|"defer"|"do"|"else"|"fallthrough"|"for"|"guard"|"if"|"in"|"repeat"|"return"|"switch"|"where"|"while"|"as"|"Any"|"catch"|"false"|"is"|"nil"|"self"|"Self"|"super"|"throw"|"throws"|"true"|"try" {
    printf("[Line %d] KEYWORD: %s\n", line_num, yytext);
}

{INT_CONST}                 { printf("[Line %d] INTEGER_CONST: %s\n", line_num, yytext); }
{FLOAT_CONST}               { printf("[Line %d] FLOAT_CONST: %s\n", line_num, yytext); }
{CHAR_CONST}                { printf("[Line %d] CHAR_CONST: %s\n", line_num, yytext); }
{STRING_LITERAL}            { printf("[Line %d] STRING_LITERAL: %s\n", line_num, yytext); }

{IDENTIFIER}                { 
    printf("[Line %d] IDENTIFIER: %s\n", line_num, yytext); 
    insertSymbol(yytext, "Identifier", line_num);
}

    /* Swift Operators */
"..."|"\.\.<"               { printf("[Line %d] RANGE_OP: %s\n", line_num, yytext); }
"->"                        { printf("[Line %d] ARROW_OP: %s\n", line_num, yytext); }
"??"                        { printf("[Line %d] NIL_COALESCING_OP: %s\n", line_num, yytext); }
"++"|"--"                   { printf("[Line %d] INC_DEC_OP: %s\n", line_num, yytext); }
"=="|"!="|"<="|">="|"<"|">" { printf("[Line %d] RELATIONAL_OP: %s\n", line_num, yytext); }
"&&"|"||"|"!"               { printf("[Line %d] LOGICAL_OP: %s\n", line_num, yytext); }
"+="|"-="|"*="|"/="|"%="|"=" { printf("[Line %d] ASSIGNMENT_OP: %s\n", line_num, yytext); }
"<<"|">>"|"&"|"|"|"^"|"~"   { printf("[Line %d] BITWISE_OP: %s\n", line_num, yytext); }
"+"|"-"|"*"|"/"|"%"         { printf("[Line %d] ARITHMETIC_OP: %s\n", line_num, yytext); }

    /* Punctuation */
"("                         { printf("[Line %d] PUNCTUATION: (\n", line_num); }
")"                         { printf("[Line %d] PUNCTUATION: )\n", line_num); }
"{"                         { printf("[Line %d] PUNCTUATION: {\n", line_num); }
"}"                         { printf("[Line %d] PUNCTUATION: }\n", line_num); }
"["                         { printf("[Line %d] PUNCTUATION: [\n", line_num); }
"]"                         { printf("[Line %d] PUNCTUATION: ]\n", line_num); }
";"                         { printf("[Line %d] PUNCTUATION: ;\n", line_num); }
","                         { printf("[Line %d] PUNCTUATION: ,\n", line_num); }
"."                         { printf("[Line %d] PUNCTUATION: .\n", line_num); }
":"                         { printf("[Line %d] PUNCTUATION: :\n", line_num); }
"?"                         { printf("[Line %d] PUNCTUATION: ?\n", line_num); }
"@"                         { printf("[Line %d] PUNCTUATION: @\n", line_num); }

.                           { printf("[Line %d] UNKNOWN_TOKEN: %s\n", line_num, yytext); }

%%

int main() {
    char filename[256];
    printf("Enter Swift source filename: ");
    if (scanf("%255s", filename) != 1) {
        fprintf(stderr, "Error reading filename.\n");
        return 1;
    }

    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Error opening source file");
        return 1;
    }

    // Input buffering via yyin
    yyin = file;

    printf("\n======================= TOKEN STREAM =======================\n");
    yylex();

    fclose(file);
    printSymbolTable();

    return 0;
}
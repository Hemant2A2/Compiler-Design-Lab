%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

/* Node structure for the symbol table hash chains */
typedef struct SymbolNode {
    char name[128];
    char type[64];
    int line_declared;
    struct SymbolNode* next;
} SymbolNode;

SymbolNode* symbolTable[TABLE_SIZE];

/* djb2 hash function */
unsigned int hash(const char* str) {
    unsigned int hash_val = 5381;
    int c;
    while ((c = *str++)) {
        hash_val = ((hash_val << 5) + hash_val) + c;
    }
    return hash_val % TABLE_SIZE;
}

/* Insert identifier into the symbol table if not already present */
void insertSymbol(const char* name, const char* type, int line) {
    unsigned int idx = hash(name);
    SymbolNode* current = symbolTable[idx];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return; // Duplicate identifier already recorded
        }
        current = current->next;
    }

    SymbolNode* newNode = (SymbolNode*)malloc(sizeof(SymbolNode));
    if (!newNode) {
        fprintf(stderr, "Memory allocation failed for symbol table node.\n");
        exit(1);
    }
    strncpy(newNode->name, name, sizeof(newNode->name) - 1);
    newNode->name[sizeof(newNode->name) - 1] = '\0';
    strncpy(newNode->type, type, sizeof(newNode->type) - 1);
    newNode->type[sizeof(newNode->type) - 1] = '\0';
    newNode->line_declared = line;
    newNode->next = symbolTable[idx];
    symbolTable[idx] = newNode;
}

/* Display the formatted symbol table */
void printSymbolTable() {
    printf("\n======================== SYMBOL TABLE ========================\n");
    printf("%-22s | %-15s | %-15s\n", "Identifier Name", "Type", "Line Declared");
    printf("--------------------------------------------------------------\n");
    for (int i = 0; i < TABLE_SIZE; i++) {
        SymbolNode* curr = symbolTable[i];
        while (curr != NULL) {
            printf("%-22s | %-15s | %-15d\n", curr->name, curr->type, curr->line_declared);
            curr = curr->next;
        }
    }
    printf("==============================================================\n\n");
}

int line_num = 1;
%}

%option noyywrap

/* Regular Expression Definitions */
DIGIT           [0-9]
HEX_DIGIT       [0-9a-fA-F]
OCT_DIGIT       [0-7]
LETTER          [a-zA-Z_]

/* Integer Constants: Decimal, Octal (starts with 0), Hexadecimal (starts with 0x/0X) */
DECIMAL_CONST   [1-9]{DIGIT}*|0
OCTAL_CONST     0{OCT_DIGIT}+
HEX_CONST       0[xX]{HEX_DIGIT}+
INT_CONST       {HEX_CONST}|{OCTAL_CONST}|{DECIMAL_CONST}

/* Floating-Point Constants: Fractional with optional exponent, or integer with exponent */
EXPONENT        ([eE][+-]?{DIGIT}+)
FLOAT_CONST     ({DIGIT}+\.{DIGIT}*{EXPONENT}?|\.{DIGIT}+{EXPONENT}?|{DIGIT}+{EXPONENT})

/* Escape Sequences & Character/String Literals */
ESC_SEQ         \\(['"\\?abfnrtv]|[0-7]{1,3}|x[0-9a-fA-F]+)
CHAR_CONST      '([^'\\\n]|{ESC_SEQ})'
STRING_LITERAL  \"([^"\\\n]|{ESC_SEQ})*\"

/* C Identifiers */
IDENTIFIER      {LETTER}({LETTER}|{DIGIT})*

%%

\n                          { line_num++; }
[ \t\r\f\v]+                { /* Discard whitespace */ }

"//".*                      { /* Discard C99/C++ style single-line comment */ }
"/\*"([^*]|\*+[^*/])*\*+"/" { 
    /* Discard ANSI C multi-line comment while maintaining accurate line count */
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') line_num++;
    }
}

"#".*                       { printf("[Line %d] PREPROCESSOR: %s\n", line_num, yytext); }

    /* ANSI C 32 Standard Keywords */
"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
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

    /* Operators */
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

.                           { printf("[Line %d] UNKNOWN_TOKEN: %s\n", line_num, yytext); }

%%

int main() {
    char filename[256];
    printf("Enter C source filename: ");
    if (scanf("%255s", filename) != 1) {
        fprintf(stderr, "Error: Invalid filename input.\n");
        return 1;
    }

    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Error opening source file");
        return 1;
    }

    // Assigning to yyin allows Flex to use its internal 16KB chunk buffer (YY_BUF_SIZE)
    yyin = file;

    printf("\n======================= TOKEN STREAM =======================\n");
    yylex();

    fclose(file);
    printSymbolTable();

    return 0;
}
#pragma once

#include "Reader/CodeLoc.h"

enum TokenType {
    OPEN_PAREN,         //  (
    CLOSE_PAREN,        //  )
    OPEN_BRACE,         //  {
    CLOSE_BRACE,        //  }
    OPEN_BRACKET,       //  [
    CLOSE_BRACKET,      //  ]
    COMMA,              //  ,
    SEMICOLON,          //  ;
    MINUS,              //  -
    PLUS,               //  +
    DIV,                //  /
    MUL,                //  *
    MOD,                //  %
    NOT,                //  !
    NOT_EQUAL,          //  !=
    ASSIGN,             //  =
    EQUAL,              //  ==
    GREATER,            //  >
    GREATER_EQUAL,      //  >=
    LESS,               //  <
    LESS_EQUAL,         //  <=
    IDENTIFIER,         //  variable
    INTEGER_LIT,        //  5
    FLOAT_LIT,          //  5.5
    TYPE_INTEGER,       //  int
    TYPE_FLOAT,         //  float
    AND,                //  and
    ELSE,               //  else
    FALSE,              //  false
    FOR,                //  for
    IF,                 //  if
    OR,                 //  or
    RETURN,             //  return
    TRUE,               //  true
    WHILE,              //  while
    BREAK,              //  break   
    CASE,               //  case    
    CONST,              //  const
    CONTINUE,           //  continue
    DEFAULT,            //  default
    DO,                 //  do
    COMMENT,            //  //
    END_OF_FILE,        //  EOF
    INVALID
};

struct Token {
    enum TokenType type;
    const char *lexeme;
    struct CodeLoc codeLoc;
};

struct Token Token_create(enum TokenType type);

struct Token Token_create_with_lexeme(
    enum TokenType type,
    const char *lexeme,
    struct CodeLoc codeLoc
);

const char *TokenType_toString(enum TokenType type);
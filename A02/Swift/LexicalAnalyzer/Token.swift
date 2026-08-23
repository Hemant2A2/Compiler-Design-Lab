import Foundation

enum TokenType: String {
    case openParen = "OPEN_PAREN"
    case closeParen = "CLOSE_PAREN"
    case openBrace = "OPEN_BRACE"
    case closeBrace = "CLOSE_BRACE"
    case openBracket = "OPEN_BRACKET"
    case closeBracket = "CLOSE_BRACKET"
    case comma = "COMMA"
    case semicolon = "SEMICOLON"

    case minus = "MINUS"
    case plus = "PLUS"
    case div = "DIV"
    case mul = "MUL"
    case mod = "MOD"

    case not = "NOT"
    case notEqual = "NOT_EQUAL"
    case assign = "ASSIGN"
    case equal = "EQUAL"
    case greater = "GREATER"
    case greaterEqual = "GREATER_EQUAL"
    case less = "LESS"
    case lessEqual = "LESS_EQUAL"

    case bitAnd = "BIT_AND"
    case bitOr = "BIT_OR"
    case bitXor = "BIT_XOR"
    case bitNot = "BIT_NOT"
    case logicalAnd = "LOGICAL_AND"
    case logicalOr = "LOGICAL_OR"
    case increment = "INCREMENT"
    case decrement = "DECREMENT"
    case plusAssign = "PLUS_ASSIGN"
    case minusAssign = "MINUS_ASSIGN"
    case mulAssign = "MUL_ASSIGN"
    case divAssign = "DIV_ASSIGN"
    case modAssign = "MOD_ASSIGN"
    case andAssign = "AND_ASSIGN"
    case orAssign = "OR_ASSIGN"
    case xorAssign = "XOR_ASSIGN"
    case leftShift = "LEFT_SHIFT"
    case rightShift = "RIGHT_SHIFT"
    case leftShiftAssign = "LEFT_SHIFT_ASSIGN"
    case rightShiftAssign = "RIGHT_SHIFT_ASSIGN"
    case question = "QUESTION"
    case colon = "COLON"
    case dot = "DOT"
    case arrow = "ARROW"
    case hash = "HASH"
    case ellipsis = "ELLIPSIS"

    case identifier = "IDENTIFIER"
    case integerLiteral = "INTEGER_LIT"
    case floatLiteral = "FLOAT_LIT"
    case charLiteral = "CHAR_LIT"
    case stringLiteral = "STRING_LIT"

    case typeVoid = "TYPE_VOID"
    case typeChar = "TYPE_CHAR"
    case typeInteger = "TYPE_INTEGER"
    case typeFloat = "TYPE_FLOAT"
    case typeDouble = "TYPE_DOUBLE"
    case auto = "AUTO"
    case `break` = "BREAK"
    case caseKeyword = "CASE"
    case const = "CONST"
    case `continue` = "CONTINUE"
    case `default` = "DEFAULT"
    case doKeyword = "DO"
    case elseKeyword = "ELSE"
    case enumKeyword = "ENUM"
    case extern = "EXTERN"
    case forKeyword = "FOR"
    case goto = "GOTO"
    case ifKeyword = "IF"
    case inline = "INLINE"
    case long = "LONG"
    case register = "REGISTER"
    case restrict = "RESTRICT"
    case returnKeyword = "RETURN"
    case short = "SHORT"
    case signed = "SIGNED"
    case sizeof = "SIZEOF"
    case `static` = "STATIC"
    case structKeyword = "STRUCT"
    case switchKeyword = "SWITCH"
    case typedef = "TYPEDEF"
    case union = "UNION"
    case unsigned = "UNSIGNED"
    case volatile = "VOLATILE"
    case whileKeyword = "WHILE"
    case bool = "BOOL"
    case complex = "COMPLEX"
    case imaginary = "IMAGINARY"
    case atomic = "ATOMIC"
    case generic = "GENERIC"
    case noreturn = "NORETURN"
    case staticAssert = "STATIC_ASSERT"
    case threadLocal = "THREAD_LOCAL"

    case comment = "COMMENT"
    case endOfFile = "END_OF_FILE"
    case invalid = "INVALID"
}

struct Token {
    let type: TokenType
    let lexeme: String
    let codeLoc: CodeLoc
}

extension Token {
    static func make(_ type: TokenType, _ lexeme: String, _ codeLoc: CodeLoc) -> Token {
        Token(type: type, lexeme: lexeme, codeLoc: codeLoc)
    }
}

let cKeywords: [String: TokenType] = [
    "auto": .auto,
    "break": .break,
    "case": .caseKeyword,
    "char": .typeChar,
    "const": .const,
    "continue": .continue,
    "default": .default,
    "do": .doKeyword,
    "double": .typeDouble,
    "else": .elseKeyword,
    "enum": .enumKeyword,
    "extern": .extern,
    "float": .typeFloat,
    "for": .forKeyword,
    "goto": .goto,
    "if": .ifKeyword,
    "inline": .inline,
    "int": .typeInteger,
    "long": .long,
    "register": .register,
    "restrict": .restrict,
    "return": .returnKeyword,
    "short": .short,
    "signed": .signed,
    "sizeof": .sizeof,
    "static": .static,
    "struct": .structKeyword,
    "switch": .switchKeyword,
    "typedef": .typedef,
    "union": .union,
    "unsigned": .unsigned,
    "void": .typeVoid,
    "volatile": .volatile,
    "while": .whileKeyword,
    "_Bool": .bool,
    "_Complex": .complex,
    "_Imaginary": .imaginary,
    "_Atomic": .atomic,
    "_Generic": .generic,
    "_Noreturn": .noreturn,
    "_Static_assert": .staticAssert,
    "_Thread_local": .threadLocal
]

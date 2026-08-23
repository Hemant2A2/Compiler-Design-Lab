import Foundation

final class Lexer {
    private let reader: Reader
    private(set) var tokens: [Token] = []
    private(set) var errors: [LexerError] = []
    private(set) var currentTokenIndex: Int = 0

    init(filePath: String) throws {
        reader = try Reader(filePath: filePath)
        tokenizeAll()
    }

    func getToken() -> Token? {
        guard !tokens.isEmpty, currentTokenIndex < tokens.count else { return nil }
        return tokens[currentTokenIndex]
    }

    func peekToken(ahead: Int = 1) -> Token? {
        let index = currentTokenIndex + ahead
        guard index < tokens.count else { return tokens.last }
        return tokens[index]
    }

    func advance() {
        currentTokenIndex = min(currentTokenIndex + 1, max(tokens.count - 1, 0))
    }

    func backward() {
        if currentTokenIndex > 0 {
            currentTokenIndex -= 1
        }
    }

    func nextToken() {
        advance()
    }

    func getCodeLoc() -> CodeLoc {
        reader.getCodeLoc()
    }

    func isEOF() -> Bool {
        reader.isEOF()
    }

    func expect(_ expectedType: TokenType) -> Bool {
        guard let token = getToken() else {
            addError(.syntax, CodeLoc(line: 1, column: 1), CodeLoc(line: 1, column: 1), "Expected \(expectedType.rawValue), but reached end of token stream")
            return false
        }
        guard token.type == expectedType else {
            addError(.syntax, token.codeLoc, token.codeLoc, "Expected \(expectedType.rawValue), but got '\(token.lexeme)'")
            return false
        }
        nextToken()
        return true
    }

    func printTokens() {
        for token in tokens {
            print(String(format: "Token: %@ | Lexeme: %@ | Line: %d | Column: %d", token.type.rawValue, token.lexeme, token.codeLoc.line, token.codeLoc.column))
        }
    }

    func printErrors() {
        for error in errors {
            fputs(error.formatted() + "\n", stderr)
        }
    }

    private func addError(_ type: ErrorType, _ start: CodeLoc, _ end: CodeLoc, _ message: String) {
        errors.append(LexerError(type: type, start: start, end: end, message: message))
    }

    private func tokenizeAll() {
        while true {
            skipWhitespace()
            let token = consumeToken()
            if token.type != .comment {
                tokens.append(token)
            }
            if token.type == .endOfFile {
                break
            }
        }
    }

    private func skipWhitespace() {
        while let ch = reader.getChar(), ch.isWhitespace {
            reader.nextChar()
        }
    }

    private func consumeToken() -> Token {
        guard let ch = reader.getChar() else {
            return Token.make(.endOfFile, "EOF", reader.getCodeLoc())
        }

        let loc = reader.getCodeLoc()

        if ch.isLetter || ch == "_" {
            return consumeIdentifierOrKeyword()
        }

        if ch.isNumber {
            return consumeNumber()
        }

        if ch == "'" {
            return consumeCharacterLiteral()
        }

        if ch == "\"" {
            return consumeStringLiteral()
        }

        switch ch {
        case "(": return single(.openParen, "(", at: loc)
        case ")": return single(.closeParen, ")", at: loc)
        case "{": return single(.openBrace, "{", at: loc)
        case "}": return single(.closeBrace, "}", at: loc)
        case "[": return single(.openBracket, "[", at: loc)
        case "]": return single(.closeBracket, "]", at: loc)
        case ",": return single(.comma, ",", at: loc)
        case ";": return single(.semicolon, ";", at: loc)
        case "?": return single(.question, "?", at: loc)
        case ":": return single(.colon, ":", at: loc)
        case "#": return single(.hash, "#", at: loc)

        case ".":
            if reader.peek(1) == "." && reader.peek(2) == "." {
                reader.nextChar(); reader.nextChar(); reader.nextChar()
                return Token.make(.ellipsis, "...", loc)
            }
            return single(.dot, ".", at: loc)

        case "+": return consumePlus(at: loc)
        case "-": return consumeMinus(at: loc)
        case "*": return consumeStar(at: loc)
        case "/": return consumeSlash(at: loc)
        case "%": return consumePercent(at: loc)
        case "!": return consumeBang(at: loc)
        case "=": return consumeEqual(at: loc)
        case "<": return consumeLess(at: loc)
        case ">": return consumeGreater(at: loc)
        case "&": return consumeAmpersand(at: loc)
        case "|": return consumePipe(at: loc)
        case "^": return consumeCaret(at: loc)
        case "~": return single(.bitNot, "~", at: loc)

        default:
            let bad = String(ch)
            reader.nextChar()
            addError(.lexical, loc, loc, "Invalid character '\(bad)'")
            return Token.make(.invalid, bad, loc)
        }
    }

    private func consumeIdentifierOrKeyword() -> Token {
        let start = reader.getCodeLoc()
        var lexeme = ""
        while let ch = reader.getChar(), ch.isLetter || ch.isNumber || ch == "_" {
            lexeme.append(ch)
            reader.nextChar()
        }
        let type = cKeywords[lexeme] ?? .identifier
        return Token.make(type, lexeme, start)
    }

    private func consumeNumber() -> Token {
        let start = reader.getCodeLoc()
        var lexeme = ""
        var isFloat = false

        while let ch = reader.getChar(), ch.isNumber {
            lexeme.append(ch)
            reader.nextChar()
        }

        if reader.getChar() == "." {
            isFloat = true
            lexeme.append(".")
            reader.nextChar()

            if reader.getChar()?.isNumber != true {
                addError(.lexical, reader.getCodeLoc(), reader.getCodeLoc(), "Invalid floating-point literal: expected digit after '.'")
            }

            while let ch = reader.getChar(), ch.isNumber {
                lexeme.append(ch)
                reader.nextChar()
            }
        }

        if reader.getChar() == "." {
            let errorLoc = reader.getCodeLoc()
            addError(.lexical, errorLoc, errorLoc, "Invalid numeric literal: multiple decimal points")
            while let ch = reader.getChar(), ch.isNumber || ch == "." {
                reader.nextChar()
            }
        }

        if let ch = reader.getChar(), ch.isLetter || ch == "_" {
            let errorLoc = reader.getCodeLoc()
            while let ch = reader.getChar(), ch.isLetter || ch.isNumber || ch == "_" {
                reader.nextChar()
            }
            addError(.lexical, errorLoc, errorLoc, "Invalid numeric literal '\(lexeme)' followed by identifier characters")
        }

        return Token.make(isFloat ? .floatLiteral : .integerLiteral, lexeme, start)
    }

    private func consumeCharacterLiteral() -> Token {
        let start = reader.getCodeLoc()
        var lexeme = "'"
        reader.nextChar()

        guard reader.getChar() != nil else {
            addError(.lexical, start, start, "Unterminated character literal")
            return Token.make(.invalid, lexeme, start)
        }

        if reader.getChar() == "\\" {
            lexeme.append("\\")
            reader.nextChar()
            if let escaped = reader.getChar() {
                lexeme.append(escaped)
                reader.nextChar()
            } else {
                addError(.lexical, start, reader.getCodeLoc(), "Unterminated character literal")
                return Token.make(.invalid, lexeme, start)
            }
        } else if let value = reader.getChar(), value != "'" && value != "\n" {
            lexeme.append(value)
            reader.nextChar()
        } else {
            addError(.lexical, start, reader.getCodeLoc(), "Empty or invalid character literal")
            return Token.make(.invalid, lexeme, start)
        }

        guard reader.getChar() == "'" else {
            addError(.lexical, start, reader.getCodeLoc(), "Unterminated character literal")
            return Token.make(.invalid, lexeme, start)
        }

        lexeme.append("'")
        reader.nextChar()
        return Token.make(.charLiteral, lexeme, start)
    }

    private func consumeStringLiteral() -> Token {
        let start = reader.getCodeLoc()
        var lexeme = "\""
        reader.nextChar()

        while let ch = reader.getChar() {
            if ch == "\"" {
                lexeme.append(ch)
                reader.nextChar()
                return Token.make(.stringLiteral, lexeme, start)
            }

            if ch == "\n" {
                addError(.lexical, start, reader.getCodeLoc(), "Unterminated string literal")
                return Token.make(.invalid, lexeme, start)
            }

            if ch == "\\" {
                lexeme.append(ch)
                reader.nextChar()
                if let escaped = reader.getChar() {
                    lexeme.append(escaped)
                    reader.nextChar()
                } else {
                    addError(.lexical, start, reader.getCodeLoc(), "Unterminated string literal")
                    return Token.make(.invalid, lexeme, start)
                }
            } else {
                lexeme.append(ch)
                reader.nextChar()
            }
        }

        addError(.lexical, start, reader.getCodeLoc(), "Unterminated string literal")
        return Token.make(.invalid, lexeme, start)
    }

    private func consumePlus(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "+" { reader.nextChar(); return Token.make(.increment, "++", loc) }
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.plusAssign, "+=", loc) }
        return Token.make(.plus, "+", loc)
    }

    private func consumeMinus(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "-" { reader.nextChar(); return Token.make(.decrement, "--", loc) }
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.minusAssign, "-=", loc) }
        if reader.getChar() == ">" { reader.nextChar(); return Token.make(.arrow, "->", loc) }
        return Token.make(.minus, "-", loc)
    }

    private func consumeStar(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.mulAssign, "*=", loc) }
        return Token.make(.mul, "*", loc)
    }

    private func consumeSlash(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "/" {
            let start = loc
            reader.nextLine()
            return Token.make(.comment, "//", start)
        }
        if reader.getChar() == "*" {
            reader.nextChar()
            while true {
                if reader.isEOF() {
                    addError(.lexical, loc, reader.getCodeLoc(), "Unterminated block comment")
                    return Token.make(.comment, "/*", loc)
                }
                if reader.getChar() == "*" && reader.peek(1) == "/" {
                    reader.nextChar(); reader.nextChar()
                    return Token.make(.comment, "/*...*/", loc)
                }
                reader.nextChar()
            }
        }
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.divAssign, "/=", loc) }
        return Token.make(.div, "/", loc)
    }

    private func consumePercent(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.modAssign, "%=", loc) }
        return Token.make(.mod, "%", loc)
    }

    private func consumeBang(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.notEqual, "!=", loc) }
        return Token.make(.not, "!", loc)
    }

    private func consumeEqual(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.equal, "==", loc) }
        return Token.make(.assign, "=", loc)
    }

    private func consumeLess(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.lessEqual, "<=", loc) }
        if reader.getChar() == "<" {
            reader.nextChar()
            if reader.getChar() == "=" { reader.nextChar(); return Token.make(.leftShiftAssign, "<<=", loc) }
            return Token.make(.leftShift, "<<", loc)
        }
        return Token.make(.less, "<", loc)
    }

    private func consumeGreater(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.greaterEqual, ">=", loc) }
        if reader.getChar() == ">" {
            reader.nextChar()
            if reader.getChar() == "=" { reader.nextChar(); return Token.make(.rightShiftAssign, ">>=", loc) }
            return Token.make(.rightShift, ">>", loc)
        }
        return Token.make(.greater, ">", loc)
    }

    private func consumeAmpersand(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "&" { reader.nextChar(); return Token.make(.logicalAnd, "&&", loc) }
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.andAssign, "&=", loc) }
        return Token.make(.bitAnd, "&", loc)
    }

    private func consumePipe(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "|" { reader.nextChar(); return Token.make(.logicalOr, "||", loc) }
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.orAssign, "|=", loc) }
        return Token.make(.bitOr, "|", loc)
    }

    private func consumeCaret(at loc: CodeLoc) -> Token {
        reader.nextChar()
        if reader.getChar() == "=" { reader.nextChar(); return Token.make(.xorAssign, "^=", loc) }
        return Token.make(.bitXor, "^", loc)
    }

    private func single(_ type: TokenType, _ lexeme: String, at loc: CodeLoc) -> Token {
        reader.nextChar()
        return Token.make(type, lexeme, loc)
    }

}

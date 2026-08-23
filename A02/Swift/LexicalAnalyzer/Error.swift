import Foundation

enum ErrorType: String {
    case lexical = "Lexical Error"
    case syntax = "Syntax Error"
}

struct LexerError {
    let type: ErrorType
    let start: CodeLoc
    let end: CodeLoc
    let message: String

    func formatted() -> String {
        if start.line == end.line && start.column == end.column {
            return "\(type.rawValue) at line \(start.line), column \(start.column): \(message)"
        }
        return "\(type.rawValue) at line \(start.line), column \(start.column) to line \(end.line), column \(end.column): \(message)"
    }
}

import Foundation

let inputPath = "Input/input.c"
let outputPath = "Output/output.txt"

func runLexer() throws {
    let lexer = try Lexer(filePath: inputPath)

    var output = ""
    output += "========== TOKENS ==========\n\n"

    for token in lexer.tokens {
        output += String(
            format: "Token: %@ | Lexeme: %@ | Line: %d | Column: %d\n",
            token.type.rawValue,
            token.lexeme,
            token.codeLoc.line,
            token.codeLoc.column
        )
    }

    output += "\n============================\n"
    output += "\n========== LEXICAL ERRORS ==========\n\n"

    if lexer.errors.isEmpty {
        output += "No lexical errors found.\n"
    } else {
        for error in lexer.errors {
            output += error.formatted() + "\n"
        }
    }

    output += "\n=====================================\n"

    print(output, terminator: "")
    try output.write(toFile: outputPath, atomically: true, encoding: .utf8)
}

do {
    try runLexer()
} catch {
    fputs("Failed to initialize lexer: \(error)\n", stderr)
    exit(1)
}

import Foundation

final class Reader {
    private let source: [Character]
    private(set) var index: Int = 0
    private(set) var currentCharacter: Character? = nil
    private(set) var codeLoc = CodeLoc(line: 1, column: 1)

    init(filePath: String) throws {
        let contents = try String(contentsOfFile: filePath, encoding: .utf8)
        self.source = Array(contents)
        if !source.isEmpty {
            currentCharacter = source[0]
        }
    }

    func getChar() -> Character? {
        currentCharacter
    }

    func getCodeLoc() -> CodeLoc {
        codeLoc
    }

    func nextChar() {
        guard currentCharacter != nil else { return }

        if currentCharacter == "\n" {
            index += 1
            codeLoc.line += 1
            codeLoc.column = 1
        } else {
            index += 1
            codeLoc.column += 1
        }

        currentCharacter = index < source.count ? source[index] : nil
    }

    func nextLine() {
        guard currentCharacter != nil else { return }

        while let ch = currentCharacter, ch != "\n" {
            nextChar()
        }

        if currentCharacter == "\n" {
            nextChar()
        }
    }

    func peek(_ offset: Int = 1) -> Character? {
        let target = index + offset
        guard target >= 0 && target < source.count else { return nil }
        return source[target]
    }

    func isEOF() -> Bool {
        currentCharacter == nil
    }
}

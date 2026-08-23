import Foundation

struct CodeLoc: CustomStringConvertible {
    var line: Int
    var column: Int

    var description: String {
        "line \(line), column \(column)"
    }
}

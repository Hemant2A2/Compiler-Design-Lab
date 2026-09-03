#if DEBUG
import Foundation
#endif

// A simple structure
struct Account {
    var balance: Double = 1250.75
    let flags: Int = 0b1011_0010
    let octVal: Int = 0o755
    
    func withdraw(amount: Double) -> Bool {
        if amount <= balance && amount > 0.0 {
            return true
        }
        return false
    }
}
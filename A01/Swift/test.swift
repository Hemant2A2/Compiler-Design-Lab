func calculateSum() -> Int {
    var sum = 0
    for number in 1...10 {
        sum += number
    }
    return sum
}

let result = calculateSum()
print("The sum of numbers from 1 to 10 is: \(result)")





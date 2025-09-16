import UIKit

enum operatorType {
 case add, subtract, multiply, divide
}
var operatorCount: Int = 0

var value1: Int = 0
var value2: String = ""
var values: [String] = [""]
var operators: [operatorType] = []
@MainActor func numberButtonPressed(_ num: Int) {
    if values.count < operatorCount + 1 {
        values.append("0")
    }
    values[operatorCount] += String(num)
}
@MainActor func operatorButtonPressed(_ buttonPressed: operatorType) {
    switch buttonPressed {
    case .add:
        operators.append(.add)
        operatorCount += 1
    case .subtract:
        operators.append(.subtract)
        operatorCount += 1
    case .multiply:
        operators.append(.multiply)
        operatorCount += 1
    case .divide:
        operators.append(.divide)
        operatorCount += 1
        
    }
}
@MainActor func clearButtonPressed() {
    values = [""]
    operatorCount = 0
    
}
@MainActor func equalButtonPressed() -> Int {
    
    var nums = values.compactMap { Int($0) }
    var ops = operators
    var i = 0
    while i < ops.count {
        switch ops[i] {
        case .multiply:
            nums[i] = nums[i] * nums[i + 1]
            nums.remove(at: i + 1)
            ops.remove(at: i)
        case .divide:
            nums[i] = nums[i] / nums[i + 1]
            nums.remove(at: i + 1)
            ops.remove(at: i)
        default:
            i += 1
        }
    }

    // Step 3: Handle addition/subtraction
    var result = nums[0]
    for (idx, op) in ops.enumerated() {
        switch op {
        case .add:
            result += nums[idx + 1]
        case .subtract:
            result -= nums[idx + 1]
        default:
            break
        }
    }
    return result
}



numberButtonPressed(1)
numberButtonPressed(2)
operatorButtonPressed(.add)
numberButtonPressed(7)
operatorButtonPressed(.multiply)
numberButtonPressed(2)
print(equalButtonPressed())


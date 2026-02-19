import UIKit

enum operatorType {
 case add, subtract, multiply, divide, percent, signChange
}
var values: [String] = [""]
var operators: [operatorType] = []

@MainActor func numberButtonPressed(_ num: Int) {
    switch num {
    case 0...9:
        if values.count < operators.count + 1 {
            values.append("0")
        }
        values[operators.count] += String(num)
    default:
        break
    }
}
@MainActor func decimalButtonPressed() {
    if values.count > operators.count { //If last value was a number
        if !values[operators.count].contains(".") {
            values[operators.count] += "."
        }
    }
}
@MainActor func invertSignButtonPressed() {
    guard operators.count < values.count else { return }
    if var valuesDouble = Double(values[operators.count]) {
        values[operators.count] = String(valuesDouble * -1)
        //creates a double of current value, changes it into an inverse value, and returns it as a string
    }
}
@MainActor func additionButtonPressed() {
    if values.count > operators.count {
        operators.append(.add)
    } else {
        operators.removeLast()
        operators.append(.add) //If last value entered was an operator, replaces it with addition
    }
}
@MainActor func subtractionButtonPressed() {
    if values.count > operators.count {
        operators.append(.subtract)
    } else {
        operators.removeLast()
        operators.append(.subtract)
    }
}
@MainActor func multiplicationButtonPressed() {
    if values.count > operators.count {
        operators.append(.multiply)
    } else {
        operators.removeLast()
        operators.append(.multiply)
    }
}
@MainActor func divisionButtonPressed() {
    if values.count > operators.count {
        operators.append(.divide)
    } else {
        operators.removeLast()
        operators.append(.divide)
    }
}

@MainActor func allClearButtonPressed() {
    values = [""]
    operators = []
}

@MainActor func deleteButtonPressed() {
    if values.count == operators.count {
        operators.removeLast() //If last value was an operator, remove the operator
    } else {
        if var lastValue = values.last, !lastValue.isEmpty {
            lastValue.removeLast()
            values[values.count - 1] = lastValue //If last value was a number, remove last character of the string
        }
    }
}
@MainActor func equalButtonPressed() -> Double {
    var valuesDouble = values.compactMap { Double($0) } //Creates a new array of doubles raather than strings
    var index = 0
    // multiplication/division - Goes through all of these operators first
    while index < operators.count {
        switch operators[index] {
        case .multiply:
            valuesDouble[index] = valuesDouble[index] * valuesDouble[index + 1]
            valuesDouble.remove(at: index + 1)
            operators.remove(at: index) //remove number from index that was multiplied by, as well as the multiplication operator
        case .divide:
            valuesDouble[index] = valuesDouble[index] / valuesDouble[index + 1]
            valuesDouble.remove(at: index + 1)
            operators.remove(at: index)
        default:
            index += 1 //pass over the addition or subtraction operators
        }
    }
    // Addition/subtraction - goes through these operators only after multiplication and division
    var result = valuesDouble[0] //Create the result, which is currently the first index of values. If there are no addition or subtraction operators this will be the answer, if not then it is the value that will run through the for in loop
    for (index, operators) in operators.enumerated() {
        switch operators {
        case .add:
            result += valuesDouble[index + 1]
        case .subtract:
            result -= valuesDouble[index + 1]
        default:
            break
        }
    }
    return result
}



//2/8*3
numberButtonPressed(8)
divisionButtonPressed()
numberButtonPressed(2)
multiplicationButtonPressed()
numberButtonPressed(3)
print(equalButtonPressed())

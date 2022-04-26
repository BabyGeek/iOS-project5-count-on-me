//
//  CalculatorBrain.swift
//  CountOnMe
//
//  Created by Paul Oggero on 13/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

// MARK: - Base model and base checks
class CalculatorModel {
    var numbers: [Float] = [Float]()
    var operands: [Operator] = [Operator]()
    var shortenCalculString: String = ""
    var result: Float?

    /// Check the elements count is enough for calcul
    /// - Parameter elements: elements array
    /// - Returns: Boolean, true if count of elements is greater than or equal to 3
    func checkCountElements() -> Bool {
        let elements = getElements()

        return elements.count >= 3
    }

    /// check if the last element of the elements is an operator or an "=" sign
    /// - Parameter elements: the elements array
    /// - Returns: Boolean depending on last element character
    func checkLastElement() -> Bool {
        guard let element = getElements().last else { return false }

        return Operator.init(rawValue: element) != nil ? true : false
    }

    /// Check if the current elements create a correct expression
    /// - Returns: true or false
    func checkExpressionIsCorrect() -> Bool {
        return operands.isEmpty ? false : numbers.count > operands.count
    }

    /// Check if the last element of the array is an operand
    /// - Parameter elements: the elements of the calcul to check
    /// - Returns: return true or false
    func checkIfLastElementIsOperand() -> Bool {
        guard let element = getElements().last else { return false }

        return Operator.init(rawValue: element) != nil ? true : false
    }

    /// Check if we can add an operand
    /// - Parameter elements: the elements of the calcul to check
    /// - Returns: true if we can, can throw error operandFirstPosition
    func checkIfCanAddOperator() -> Bool {
        !checkIfLastElementIsOperand() && !(getElements().isEmpty)
    }

    /// check if a calcul as already been done by checking the "=" sign
    /// - Parameter text: the text currently displayed in the view
    /// - Returns: boolean depending if a calcul as been done or not
    func checkCalculDoneFor(_ text: String) -> Bool {
        text.firstIndex(of: "=") != nil
    }
}

// MARK: - Add number and operand to the calcul
extension CalculatorModel {
    /// Add a number to the numbers
    /// - Parameter number: number to add
    func addNumber(_ number: Float) {
        self.numbers.append(number)
    }

    /// Add an operator to the operands
    /// - Parameter operand: operand to add
    func addOperand(_ operand: Operator) {
        operands.append(operand)
    }

}

// MARK: - Gestion of elements
extension CalculatorModel {
    /// Clean elements, will return the last calcul after = sign if chaining calculs,
    /// other will return the first calcul it founds
    /// - Parameter elements: the array of elements in the text
    /// - Returns: array of elements to keep in reality for the calcul
    private func cleanElements(_ elements: [String]) throws -> [String] {
        var elementsRefactored: [String] = elements

        if checkCalculDoneFor(elementsRefactored.joined(separator: " ")) {
            for index in elementsRefactored.indices {
                if elementsRefactored[index] == "=" {
                    elementsRefactored.removeSubrange(0...index)

                    if checkCalculDoneFor(elementsRefactored.joined(separator: " ")) {
                        return try cleanElements(elementsRefactored)
                    }

                    break
                }
            }
        }

        return try getPrioritarizedElements(elementsRefactored)
    }

    /// Get elements iwith calculs priorities done
    /// - Parameter elements: elements of the calcul array of strings
    /// - Returns: Array of elements with priorities done
    private func getPrioritarizedElements(_ elements: [String]) throws -> [String] {
        var prioritarizedElements: [String] = elements

        for index in elements.indices {
            if let operand = Operator.init(rawValue: elements[index]) {
                if operand.isPrioritary && index > 2 {
                    if let left = Float(elements[index - 1]), let right = Float(elements[index + 1]) {
                        let priorityCalcul = try doCalcul(
                            left: left,
                            right: right,
                            operand: operand
                        )

                        prioritarizedElements[index - 1] = String(priorityCalcul)
                        prioritarizedElements.remove(at: index)
                        prioritarizedElements.remove(at: index)
                    }

                    return try getPrioritarizedElements(prioritarizedElements)
                }
            }
        }

        shortenCalculString = prioritarizedElements.joined(separator: " ")

        return prioritarizedElements
    }

    /// Get the elements array for the calcul
    /// - Returns: Array of string elements
    private func getElements() -> [String] {
        var elements = [String]()
        var operandsTemp = operands

        for index in numbers.indices {
            if index > 0 {
                if operandsTemp.count > 0 {
                    elements.append(operandsTemp.first!.rawValue)
                    operandsTemp.remove(at: 0)
                }
            }

            elements.append(String(numbers[index]))

        }

        if operandsTemp.count == 1 {
            elements.append(operandsTemp.first!.rawValue)
        }

        return elements
    }

    /// Clean and set current elements to work with from element array of string
    /// - Parameter elements: array of elements to use
    private func setElements(_ elements: [String]) throws {
        reset()
        let elements = try cleanElements(elements)

        for element in elements {
            if let operand = Operator.init(rawValue: element) {
                self.addOperand(operand)
            } else if let number = Float(element) {
                self.addNumber(number)
            }
        }
    }

    /// Cleanup and rebuild the numbers and operators for the calcul
    /// - Parameter elements: array of elements in the text field
    private func rebuildNumbersAndOperands() throws {
        let elementsRefactored = try cleanElements(getElements())
        reset()

        for element in elementsRefactored {
            if let operand = Operator.init(rawValue: element) {
                addOperand(operand)
            } else {
                if let number = Float(element) {
                    addNumber(number)
                }
            }
            shortenCalculString.append("\(element) ")
        }
    }
}

// MARK: - Do calcul functions
extension CalculatorModel {
    /// Execute the full calcul for an array of elements, it check the calculator build, and execute calcul loop
    /// - Returns: The final result of the calcul
    func doCalcul() throws {
        try rebuildNumbersAndOperands()
        dump(numbers)

        var resultValue: Float = numbers.first!
        numbers.remove(at: 0)

        while !numbers.isEmpty && !operands.isEmpty {
            for _ in operands {
                resultValue = try doCalcul(
                    left: resultValue,
                    right: numbers[0],
                    operand: operands[0]
                )
                numbers.remove(at: 0)
                operands.remove(at: 0)
            }
        }

        result = resultValue
        numbers.append(resultValue)
    }

    /// Do calcul from elements
    /// - Parameter elements: elements array to work with
    func doCalcul(_ elements: [String]) throws {
        try setElements(elements)
        try doCalcul()
    }

    /// Do a calcul on a and b depending on the operand
    /// - Parameters:
    ///   - right: number right of the calcul
    ///   - left: number left of the calcul
    ///   - operand: operand to use
    /// - Returns: The result of the calcul or throw an error if divided by zero
    private func doCalcul(left: Float, right: Float, operand: Operator) throws -> Float {
        switch operand {
        case .plus:
            return left + right
        case .minus:
            return left - right
        case .multiply:
            return left * right
        case .divide:
            if right == 0 {
                throw CalculationErrors.divideByZero
            } else {
                return  left / right
            }
        }
    }
}

// MARK: - Calculator get and reset
extension CalculatorModel {
    /// Shorten the text, get the priority calculs done and get more space to see the calcul
    /// - Returns: The text of the calcul shortened
    func getShortenText() -> String {
        guard let result = result else { return "" }

        return shortenCalculString + "= \(result)"
    }

    /// Reset the numbers and operands of the calculator
    func reset() {
        numbers = [Float]()
        operands = [Operator]()
        shortenCalculString = ""
        result = nil
    }
}

//
//  CalculatorBrain.swift
//  CountOnMe
//
//  Created by Paul Oggero on 13/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorModel {
    var numbers: [Float] = [Float]()
    var operands: [Operator] = [Operator]()
    var shortenCalculString: String = ""
    
    /// Check the elements count is enough for calcul
    /// - Parameter elements: elements array
    /// - Returns: Boolean, true if count of elements is greater than or equal to 3
    func checkCountElementsFor(_ elements: [String]) throws -> Bool {
        try rebuildNumbersAndOperands(elements)
        
        return elements.count >= 3
    }
    
    /// check if the last element of the elements is an operator or an "=" sign
    /// - Parameter elements: the elements array
    /// - Returns: Boolean depending on last element character
    func checkLastElementFor(_ elements: [String]) throws -> Bool {
        try rebuildNumbersAndOperands(elements)
        
        guard let element = elements.last else { return false }
        
        if elements.contains("=") {
            return false
        }
        
        return Operator.init(rawValue: element) != nil ? true : false
    }
    
    func checkExpressionIsCorrect() -> Bool {
        return operands.isEmpty ? false : numbers.count > operands.count
    }
    
    func checkIfLastElementIsOperand(_ elements: [String]) throws -> Bool {
        try rebuildNumbersAndOperands(elements)
        
        guard let element = elements.last else { return false }
        
        return Operator.init(rawValue: element) != nil ? true : false
    }
    
    func checkIfCanAddOperator(_ elements: [String]) throws -> Bool {
        do {
            return try !checkIfLastElementIsOperand(elements) && !(elements.isEmpty)
        } catch {
            throw CalculationErrors.operandFirstPosition
        }
    }
    
    func addNumber(_ number: Float) {
        self.numbers.append(number)
    }
    
    func addOperand(_ operand: Operator) {
        operands.append(operand)
    }
    
    /// check if a calcul as already been done by checking the "=" sign
    /// - Parameter text: the text currently displayed in the view
    /// - Returns: boolean depending if a calcul as been done or not
    func checkCalculDoneFor(_ text: String) -> Bool {
        text.firstIndex(of: "=") != nil
    }
    
    func doCalculFor(_ elements: [String]) throws -> Float {
        try rebuildNumbersAndOperands(elements)
        
        var resultValue: Float = numbers.first!
        numbers.remove(at: 0)
        
        while !numbers.isEmpty && !operands.isEmpty {
            for _ in operands {
                resultValue = try doCalculationForElements(left: resultValue, operand: operands[0], right: numbers[0])
                numbers.remove(at: 0)
                operands.remove(at: 0)
            }
        }
        try rebuildNumbersAndOperands(elements)
        
        shortenCalculString = shortenCalculString + " = \(resultValue)"
        return resultValue
    }
    
    func getShortenText() -> String {
        return shortenCalculString
    }
    
    /// Do the cacul
    /// - Parameter elements: the array of calcul elements
    /// - Returns: the result or throw an error of type CalculationErrors
    private func doCalculationForElements(left: Float, operand: Operator, right: Float) throws -> Float  {
        do {
            return try doCalcul(a: left, b: right, operand: operand)
        } catch CalculationErrors.unknown {
            throw CalculationErrors.unknown
        } catch CalculationErrors.operandNotFound {
            throw CalculationErrors.operandNotFound
        } catch {
            throw CalculationErrors.unknown
        }
    }
    
    private func doCalcul(a: Float, b: Float, operand: Operator) throws -> Float {
        
        switch operand {
        case .plus:
            return a + b
        case .minus:
            return a - b
        case .multiply:
            return a * b
        case .divide:
            if b == 0 {
                throw CalculationErrors.divideByZero
            } else {
                return  a / b
            }
        }
    }
    
    /// Cleanup and rebuild the numbers and operators for the calcul
    /// - Parameter elements: array of elements in the text field
    private func rebuildNumbersAndOperands(_ elements: [String]) throws {
        reset()
        let elementsRefactored = try cleanElements(elements)
        
        for element in elementsRefactored {
            if let operand = Operator.init(rawValue: element) {
                addOperand(operand)
            } else {
                if let number = Float(element) {
                    addNumber(number)
                }
            }
        }
    }
    
    /// Clean elements, will return the last calcul after = sign if chaining calculs, other will return the first calcul it founds
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
    
    private func getPrioritarizedElements(_ elements: [String]) throws -> [String] {
        var prioritarizedElements: [String] = elements
        for index in elements.indices {
            if let operand = Operator.init(rawValue: elements[index]) {
                if operand.isPrioritary && index > 2 {
                    do {
                        let priorityCalcul = try doCalcul(a: Float(elements[index - 1])!, b: Float(elements[index + 1])!, operand: operand)
                        prioritarizedElements[index - 1] = String(priorityCalcul)
                        prioritarizedElements.remove(at: index)
                        prioritarizedElements.remove(at: index)
                        
                        return try getPrioritarizedElements(prioritarizedElements)
                    } catch let error as CalculationErrors {
                        throw error
                    }
                }
            }
        }
        
        shortenCalculString = prioritarizedElements.joined(separator: " ")
        
        return prioritarizedElements
    }
    
    /// Reset the numbers and operands of the calculator
    func reset() {
        numbers = [Float]()
        operands = [Operator]()
    }
}

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
    
    /// Check the elements count is enough for calcul
    /// - Parameter elements: elements array
    /// - Returns: Boolean, true if count of elements is greater than or equal to 3
    func checkCountElementsFor(_ elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    /// check if the last element of the elements is an operator or an "=" sign
    /// - Parameter elements: the elements array
    /// - Returns: Boolean depending on last element character
    func checkLastElementFor(_ elements: [String]) -> Bool {
        guard let element = elements.last else { return false }
        
        if elements.contains("=") {
            return false
        }
        
        return Operator.init(rawValue: element) != nil ? true : false
    }
    
    func checkExpressionIsCorrect() -> Bool {
        return operands.isEmpty ? false : numbers.count > operands.count
    }
    
    func checkIfLastElementIsOperand(_ elements: [String]) -> Bool {
        guard let element = elements.last else { return false }
        
        return Operator.init(rawValue: element) != nil ? true : false
    }
    
    func addNumber(_ number: Float) {
        self.numbers.append(number)
    }
    
    func addOperand(_ operand: String) throws {
        if let operand = Operator.init(rawValue: operand) {
            self.operands.append(operand)
        } else {
            throw CalculationErrors.operandNotFound
        }
    }
    
    /// check if a calcul as already been done by checking the "=" sign
    /// - Parameter text: the text currently displayed in the view
    /// - Returns: boolean depending if a calcul as been done or not
    func checkCalculDoneFor(_ text: String) -> Bool {
        text.firstIndex(of: "=") != nil
    }
    
    func doCalculFor(_ elements: [String]) throws -> Float {
        try rebuildNumbersAndOperands(elements)

        var total: Float = try getInitCalcul(elements)
        
        print("Total : \(total)")
        
        print("\nNumbers : \(numbers)")

        let finalCalcul: [String:Any] = [
            "right": numbers.first!,
            "operand": operands.first!
        ]
        
        numbers.remove(at: 0)
        
        
        while !numbers.isEmpty && !operands.isEmpty {
            for _ in operands {
                total = try doCalculationForElements(left: total, operand: operands[0], right: numbers[0])
                numbers.remove(at: 0)
                operands.remove(at: 0)
            }
        }
        
        total = try doCalculationForElements(left: total, operand: finalCalcul["operand"] as! Operator, right: finalCalcul["right"] as! Float)
        
        try rebuildNumbersAndOperands(elements)

        return total
    }
    
    func getOperationNumbers(_ elements: [String]) -> [Float] {
        return numbers
    }
    
    func getOperationOperands(_ elements: [String]) -> [Operator]{
        return operands
    }
    
    /// Do the cacul
    /// - Parameter elements: the array of calcul elements
    /// - Returns: the result or throw an error of type CalculationErrors
    func doCalculationForElements(left: Float, operand: Operator, right: Float) throws -> Float  {
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
    
    func  doCalcul(a: Float, b: Float, operand: Operator) throws -> Float {
        
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
    
    func getChainCalculs(_ elements: [String]) -> [[String]] {
        return [[String]]()
    }
    
    func getInitCalcul(_ elements: [String]) throws -> Float {
        var elements = cleanElements(elements)

        var total: Float = 0
        
        if checkCalculDoneFor(elements.joined(separator: " ")) {
            for index in elements.indices {
                
                if elements[index] == "=" {
                    total = Float(elements[index + 1])!
                    elements = cleanElements(elements)
                    
                    
                    if checkCalculDoneFor(elements.joined(separator: " ")) {
                        return try getInitCalcul(elements)
                    }
                    
                    break
                }
            }
            
        } else {
            total = 0
        }
        
        
        
        
        return total
    }
    
    func rebuildNumbersAndOperands(_ elements: [String]) throws {
        reset()
        let elementsRefactored = cleanElements(elements)

        for element in elementsRefactored {
            if let operand = Operator.init(rawValue: element) {
                do {
                    try addOperand(operand.rawValue)
                } catch CalculationErrors.operandNotFound {
                    throw CalculationErrors.operandNotFound
                } catch {
                    throw CalculationErrors.calculationError
                }
            } else {
                if let number = Float(element) {
                    addNumber(number)
                }
            }
        }
    }
    
    func cleanElements(_ elements: [String]) -> [String] {
        var elementsRefactored: [String] = elements
        
        if checkCalculDoneFor(elementsRefactored.joined(separator: " ")) {
            for index in elementsRefactored.indices {
                if elementsRefactored[index] == "=" {
                    elementsRefactored.removeSubrange(0...index)
                    
                    if checkCalculDoneFor(elementsRefactored.joined(separator: " ")) {
                        return cleanElements(elementsRefactored)
                    }
                    
                    
                    return elementsRefactored
                }
            }
        
        }
        
        return elementsRefactored
    }
    
    func reset() {
        numbers = [Float]()
        operands = [Operator]()
    }
}

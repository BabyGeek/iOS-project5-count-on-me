//
//  CalculatorBrain.swift
//  CountOnMe
//
//  Created by Paul Oggero on 13/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorModel {
    var result: Float = 0
    var numbers: [Int] = [Int]()
    var operators: [Operator] = [Operator]()
    
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
    
    func checkIfLastElementIsOperand(_ elements: [String]) -> Bool {
        guard let element = elements.last else { return false }
        
        return Operator.init(rawValue: element) != nil ? true : false
    }
    
    func addNumber(_ number: Int) {
        self.numbers.append(number)
    }
    
    func addOperand(_ operand: String) throws {
        print(operand)
        if let operand = Operator.init(rawValue: operand) {
            print(operand)
            self.operators.append(operand)
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
    
    /// Do the cacul
    /// - Parameter elements: the array of calcul elements
    /// - Returns: the result or throw an error of type CalculationErrors
    func doCalculationForElements(_ elements: [String]) throws -> Float  {
        // Create local copy of operations
        let operationsToReduce = elements
        var finalResult: Float = 0
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            if let operand = Operator.init(rawValue: operand) {
                do {
                    try finalResult += doCalcul(a: left, b: right, operand: operand)
                } catch CalculationErrors.unknown {
                    throw CalculationErrors.unknown
                } catch CalculationErrors.operandNotFound {
                    throw CalculationErrors.operandNotFound
                }
            } else {
                throw CalculationErrors.unknown
            }
        }
        
        return finalResult
    }
    
    func doCalcul(a: Int, b: Int, operand: Operator) throws -> Float {
        let a = Float(a)
        let b = Float(b)
        
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
}

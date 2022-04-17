//
//  CalculatorBrain.swift
//  CountOnMe
//
//  Created by Paul Oggero on 13/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct CalculatorModel {
    let operators: [String] = ["+", "-", "×", "÷"]
    
    
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
        
        return !operators.contains(element)
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
    func doCalculationForElements(_ elements: [String]) throws -> Int  {
        // Create local copy of operations
        let operationsToReduce = elements
        var result: Int = 0

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷":
                if right == 0 {
                    throw CalculationErrors.divideByZero
                } else {
                    result = left / right
                }
            case "×": result = left * right
            default:
                throw CalculationErrors.notFound
            }
            
            return result
        }
        
        return result
    }
}

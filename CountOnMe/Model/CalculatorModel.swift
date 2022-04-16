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
    
    enum calculationErrors: Error {
        case divideByZero, notFound
    }

    
    func checkCountElementsFor(_ elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    func checkLastElementFor(_ elements: [String]) -> Bool {
        guard let element = elements.last else { return false }
        return operators.contains(element)
    }
    
    func doCalculationForElements(_ elements: [String]) throws -> Int?  {
        // Create local copy of operations
        let operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷":
                if right == 0 {
                    throw calculationErrors.divideByZero
                } else {
                    result = left / right
                }
            case "×": result = left * right
            default:
                throw calculationErrors.notFound
            }
            
            return result
        }
        
        return nil
    }
}

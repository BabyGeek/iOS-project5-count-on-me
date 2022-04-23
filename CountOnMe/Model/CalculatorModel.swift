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
    
    func checkExpressionIsCorrect() -> Bool {
        return operators.isEmpty ? false : numbers.count > operators.count
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
    
    func doCalculFor(_ elements: [String]) throws -> Float {
        
        var operationNumbers = numbers
        var operationOperands = operators
        
        let firstElements = numbers.prefix(2)
        var total: Float = try doCalculationForElements(left: firstElements[0], operand: operators.first!, right: firstElements[1])
        operationNumbers.remove(at: 0)
        operationNumbers.remove(at: 0)
        
        operationOperands.remove(at: 0)
        
        
        while !operationOperands.isEmpty && !operationNumbers.isEmpty {
            for index in operationOperands.indices {
                total = try doCalculationForElements(left: total, operand: operationOperands[index], right: operationNumbers.first!)
                operationNumbers.remove(at: 0)
                operationOperands.remove(at: 0)
            }
        }
        
        
        //        let elements = elements.map{
        //            ($0 as NSString).floatValue
        //        }
        //
        //        dump(elements)
        //        dump(elements)
        //
        //        var total: Float = elements.first!
        //
        //        for index in elements.indices {
        //            if let operand = Operator.init(rawValue: String(elements[index])) {
        //                total += try doCalculationForElements([String(format: "%.2f", total), operand.rawValue, String(format: "%.2f", elements[index + 1])])
        //            }
        //        }
        //
        //        dump(total)
        //
        //        if operators.count > 1 {
        //            print("chain")
        //
        //            let calculs = getChainCalculs(elements)
        //        } else {
        //            print("single")
        //
        //            let calculs = elements.chunked(into: 3)
        //        }
        //
        //        let calculs = elements.filter { $0 != "=" }.chunked(into: 3)
        //        print(calculs)
        
        //        var operationsDone = 0
        //
        //        while operationsDone < operationsToDo {
        //            for i in stride(from: 0, to: elements.count, by: 3) {
        //                do {
        //                    try total += doCalculationForElements([elements[i], operators[operationsDone].rawValue, elements[i + 2]])
        //                    operationsDone += 1
        //                } catch let error as CalculationErrors {
        //                    throw error
        //                }
        //                catch {
        //                    throw CalculationErrors.calculationError
        //                }
        //            }
        //        }
        
        return total
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
    
    func doCalcul(a: Float, b: Float, operand: Operator) throws -> Float {
        
        print(a + b)
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
    
    func reset() {
        numbers = [Float]()
        operators = [Operator]()
    }
}

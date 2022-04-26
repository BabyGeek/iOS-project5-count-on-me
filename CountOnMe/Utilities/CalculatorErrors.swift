//
//  CalculatorErrors.swift
//  CountOnMe
//
//  Created by Paul Oggero on 16/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

/// Calculation error types enumerator
enum CalculationErrors: Error {
    case divideByZero, notFound, unknown, operandNotFound, calculationError, operandFirstPosition, badOperand
}

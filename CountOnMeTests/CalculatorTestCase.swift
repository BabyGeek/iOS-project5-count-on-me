//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Paul Oggero on 25/04/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

@testable import CountOnMe
import XCTest

class CalculatorTestCase: XCTestCase {
    var calculator: CalculatorModel!

    override func setUp() {
        super.setUp()

        calculator = CalculatorModel()
    }

    // At begining operands, numbers, and text empty
    // At begining checks for calcul should be false
    // Addition 5 + 3 = 8
    // Substraction 5 - 3 = 2
    // Multiplication 5 * 3 = 15
    // Division 6 / 2 = 3
    // 5 + 3 => Check expressionCorrect behavior
    // 5 => Check canAddOperator and LastElement behavior
    // 5 + => Check lastElement behavior
    // 5 / 0 => Check dividedByZero Error throw
    // Multiple calculs in one with priority = 5 + 3 + 3 * 3 = 17
    // Chain calculs 5 + 3 = 8 + 3 * 3 = 17
    // 5 + 3 * 2 = 11 => check shortenText output = 5.0 + 6.0 = 11.0
    // Try 5 + 3 * 6 + 8 / 2 = 27 + 9 = 36 * 2 = 72 - 30 = 42 => check recusivity inside private funcs
    // Try 5 + 3 * 6 + 8 / 2 = 27 + 9 = 36 * 2 = 72 - 30 = 42  in text elements => check result is 42

    func testGivenCalculatorIsNew_WhenGettingOperandsAndNumbersAndShortenText_ThenAllShouldBeEmpty() {
        // When, Then
        XCTAssertTrue(calculator.operands.isEmpty)
        XCTAssertTrue(calculator.numbers.isEmpty)
        XCTAssertTrue(calculator.shortenCalculString.isEmpty)
    }

    func testGivenCalculatorIsNew_WhenGettingChecks_ThenChecksShouldBeFalse() {
        // When, Then
        XCTAssertTrue(!calculator.checkLastElement())
        XCTAssertTrue(!calculator.checkCountElements())
        XCTAssertTrue(!calculator.checkIfLastElementIsOperand())
        XCTAssertTrue(!calculator.checkIfCanAddOperator())
        XCTAssertTrue(!calculator.checkExpressionIsCorrect())
    }

    func testGivenCalculatorIsNew_WhenDoFivePlusTree_ThenResultShouldBeHeight() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 8)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsNew_WhenDoFiveMinusTree_ThenResultShouldBeTwo() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.minus)
        calculator.addNumber(3)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 2)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsNew_WhenDoFiveMultiplyTree_ThenResultShouldBeFifteen() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.multiply)
        calculator.addNumber(3)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 15)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsNew_WhenDoSixDevidedByTwo_ThenResultShouldBeTree() {
        // When
        calculator.addNumber(6)
        calculator.addOperand(.divide)
        calculator.addNumber(2)


        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 3)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsFivePlusTree_WhenDoCalculAndDevidedByTwo_ThenResultShouldBeFour() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When
        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }
        calculator.addOperand(.divide)
        calculator.addNumber(2)

        
        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }
        
        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 4)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsFivePlusTree_WhenGettingCorrectCheck_ThenCorrectCheckShouldBeTrue() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When, Then
        XCTAssertTrue(calculator.checkExpressionIsCorrect())
    }

    func testGivenCalculatorNumberIsFive_WhenCanAddOperandCheck_ThenCanAddOperandAndLastElementShouldBeTrueAndFalse() {
        // Given
        calculator.addNumber(5)

        // When, Then
        XCTAssertTrue(calculator.checkIfCanAddOperator())
        XCTAssertTrue(!calculator.checkLastElement())
    }

    func testGivenCalculatorNumberIsFiveAndPlus_WhenCanAddOperandCheck_ThenCanAddOperandCheckShouldBeTrue() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)

        // When, Then
        XCTAssertTrue(calculator.checkLastElement())
    }

    func testGivenCalculatorIsNew_WhenTryingToMakeDividedByZero_ThenShouldGetDivideByZeroError() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.divide)
        calculator.addNumber(0)

        // Then
        do {
            try calculator.doCalcul()
        } catch let error as CalculationErrors {
            XCTAssertEqual(error, CalculationErrors.divideByZero)
        } catch {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsFivePlusTree_WhenPlusTreeAndMultiplyByTree_ThenResultShouldBeSeventeen() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When
        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(3)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 17)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsFivePlusTree_WhenDoCalculAndPlusTreeAndMultiplyByTree_ThenResultShouldBeHeight() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When
        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(3)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 17)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsMany_WhenCheckShorten_ThenShortenTextShouldBeEmpty() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(2)

        // When, Then
        XCTAssertEqual(calculator.getShortenText(), "")
    }

    func testGivenCalculatorIsMany_WhenDoCalcul_ThenShortenTextShouldBeShorten() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(2)

        // When
        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        XCTAssertEqual(calculator.getShortenText(), "5.0 + 6.0 = 11.0")
    }

    func testGivenCalculatorIsMany_WhenDoCalculPlusMany_ThenResultShouldBeFourtyTwo() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(6)
        calculator.addOperand(.plus)
        calculator.addNumber(8)
        calculator.addOperand(.divide)
        calculator.addNumber(2)

        // When
        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.plus)
        calculator.addNumber(9)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.multiply)
        calculator.addNumber(2)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.minus)
        calculator.addNumber(30)

        do {
            try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 42)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsText_WhenDoCalculWithElement_ThenResultShouldBeFourtyTwo() {
        // Given
        let text = "5 + 3 * 6 + 8 / 2 = 27 + 9 = 36 * 2 = 72 - 30"

        // When
        let elements = text.split(separator: " ").map { "\($0)" }
        do {
            try calculator.doCalcul(elements)
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        if let result = calculator.result {
            XCTAssertEqual(result, 42)
        } else {
            XCTAssertTrue(false)
        }
    }
}

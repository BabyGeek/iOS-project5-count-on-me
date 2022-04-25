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

    func testGivenCalculatorIsNew_WhenDoFivePlusTree_ThenOutputShouldBeHeightAndFloat() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 8)
    }

    func testGivenCalculatorIsNew_WhenDoFiveMinusTree_ThenOutputShouldBeTwoAndFloat() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.minus)
        calculator.addNumber(3)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 2)
    }

    func testGivenCalculatorIsNew_WhenDoFiveMultiplyTree_ThenOutputShouldBeFifteenAndFloat() {
        // When
        calculator.addNumber(5)
        calculator.addOperand(.multiply)
        calculator.addNumber(3)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 15)
    }

    func testGivenCalculatorIsNew_WhenDoSixDevidedByTwo_ThenOutputShouldBeTreeAndFloat() {
        // When
        calculator.addNumber(6)
        calculator.addOperand(.divide)
        calculator.addNumber(2)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 3)
    }

    func testGivenCalculatorIsFivePlusTree_WhenDoCalculAndDevidedByTwo_ThenOutputShouldBeFourAndFloat() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When
        do {
            _ = try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }
        calculator.addOperand(.divide)
        calculator.addNumber(2)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 4)
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
            try _ = calculator.doCalcul()
        } catch let error as CalculationErrors {
            XCTAssertEqual(error, CalculationErrors.divideByZero)
        } catch {
            XCTAssertTrue(false)
        }
    }

    func testGivenCalculatorIsFivePlusTree_WhenPlusTreeAndMultiplyByTree_ThenOutputShouldBeSeventeenAndFloat() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When
        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(3)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 17)
    }

    func testGivenCalculatorIsFivePlusTree_WhenDoCalculAndPlusTreeAndMultiplyByTree_ThenOutputShouldBeHeightAndFloat() {
        // Given
        calculator.addNumber(5)
        calculator.addOperand(.plus)
        calculator.addNumber(3)

        // When
        do {
            _ = try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.plus)
        calculator.addNumber(3)
        calculator.addOperand(.multiply)
        calculator.addNumber(3)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 17)
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
            _ = try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        // Then
        XCTAssertEqual(calculator.getShortenText(), "5.0 + 6.0 = 11.0")
    }

    func testGivenCalculatorIsMany_WhenDoCalculPlusMany_ThenOutputShouldBeThirtyAndFloat() {
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
            _ = try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.plus)
        calculator.addNumber(9)

        do {
            _ = try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.multiply)
        calculator.addNumber(2)

        do {
            _ = try calculator.doCalcul()
        } catch {
            XCTAssertTrue(false)
        }

        calculator.addOperand(.minus)
        calculator.addNumber(30)

        // Then
        XCTAssertEqual(try calculator.doCalcul() as Float, 42)
    }
}

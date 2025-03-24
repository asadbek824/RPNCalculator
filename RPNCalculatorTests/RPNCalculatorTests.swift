//
//  RPNCalculatorTests.swift
//  RPNCalculatorTests
//
//  Created by Asadbek Yoldoshev on 3/17/25.
//

import XCTest
@testable import RPNCalculator

final class RPNServiceTests: XCTestCase {
    var rpnService: RPNServiceProtocol!

    override func setUp() {
        super.setUp()
        rpnService = RPNService()
    }

    override func tearDown() {
        rpnService = nil
        super.tearDown()
    }
    
    private func assertEvaluation(
        expression: String,
        expected: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let result = rpnService.evaluate(expression: expression)
        switch result {
        case .success(let value):
            XCTAssertEqual(value, expected, file: file, line: line)
        case .failure(let error):
            XCTFail("Ошибка: \(error)", file: file, line: line)
        }
    }
    
    func testSimpleAddition() {
        assertEvaluation(expression: "2+3", expected: "5")
    }
    
    func testSimpleSubtraction() {
        assertEvaluation(expression: "5-2", expected: "3")
    }
    
    func testSimpleMultiplication() {
        assertEvaluation(expression: "4*3", expected: "12")
    }
    
    func testSimpleDivision() {
        assertEvaluation(expression: "10/2", expected: "5")
    }
    
    func testDivisionByZero() {
        let result = rpnService.evaluate(expression: "5/0")
        switch result {
        case .success(let value):
            XCTFail("Ожидалась ошибка деления на ноль, получено значение \(value)")
        case .failure(let error):
            XCTAssertEqual(error, CalculationError.divisionByZero)
        }
    }
    
    func testNegativeNumbers() {
        assertEvaluation(expression: "-5+3", expected: "-2")
    }
    
    func testOperatorPrecedence() {
        assertEvaluation(expression: "3+5*2", expected: "13")
    }
    
    func testExpressionWithParentheses() {
        assertEvaluation(expression: "(3+5)*2", expected: "16")
    }
    
    func testNestedParentheses() {
        assertEvaluation(expression: "((2+3)*4)-5", expected: "15")
    }
    
    func testMissingClosingParenthesis() {
        assertEvaluation(expression: "(3+5*2", expected: "13")
    }
    
    func testTrailingOperator() {
        assertEvaluation(expression: "10+", expected: "10")
    }
    
    func testMultipleMissingClosingParentheses() {
        assertEvaluation(expression: "((2+3)*4", expected: "20")
    }
    
    func testExtraClosingParenthesis() {
        assertEvaluation(expression: "(3+5*2", expected: "13")
    }
    
    func testDecimalNumbers() {
        assertEvaluation(expression: "2.5+3.5", expected: "6")
    }
    
    func testMultiplicationDivisionSymbols() {
        assertEvaluation(expression: "3×3", expected: "9")
        assertEvaluation(expression: "8÷2", expected: "4")
    }
    
    func testUnaryMinusInExpression() {
        assertEvaluation(expression: "3+-2", expected: "1")
    }
    
    func testMixedOperatorsAndBrackets() {
        assertEvaluation(expression: "(1+2)*(3+4)/2", expected: "10.5")
    }
    
    func testEmptyExpression() {
        assertEvaluation(expression: "", expected: "0")
    }
    
    func testOnlyParentheses() {
        assertEvaluation(expression: "()", expected: "0")
    }
    
    func testOnlyOperator() {
        assertEvaluation(expression: "-", expected: "0")
    }
}

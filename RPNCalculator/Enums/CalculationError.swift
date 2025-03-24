//
//  CalculationError.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/19/25.
//

import Foundation

enum CalculationError: Error, Equatable {
    case invalidExpression(String)
    case divisionByZero
    case unmatchedParentheses
}

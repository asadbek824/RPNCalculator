//
//  CalculatorInput.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/17/25.
//

import Foundation

enum CalculatorInput {
    case digit(String)
    case operatorSymbol(String)
    case openBracket
    case closeBracket
    case dot
}

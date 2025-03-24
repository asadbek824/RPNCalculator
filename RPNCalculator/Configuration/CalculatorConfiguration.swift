//
//  CalculatorConfiguration.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/19/25.
//

struct CalculatorConfiguration {
    let buttonLayout: [[CalculatorButtonTypes]] = [
        [.clear, .backspace, .openBracket, .closeBracket],
        [.seven, .eight, .nine, .divide],
        [.four, .five, .six, .multiply],
        [.one, .two, .three, .subtract],
        [.zero, .dot, .equal, .add]
    ]
}

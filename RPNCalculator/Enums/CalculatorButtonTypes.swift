//
//  CalculatorButtonTypes.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/19/25.
//

import UIKit

enum CalculatorButtonTypes: String {
    // Функциональные кнопки
    case clear = "C"
    case backspace = "⌫"
    case openBracket = "("
    case closeBracket = ")"
    
    // Цифры
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    
    // Операторы
    case add = "+"
    case subtract = "-"
    case multiply = "×"
    case divide = "÷"
    case dot = "."
    case equal = "="
    
    var title: String {
        return self.rawValue
    }
    var backgroundColor: UIColor {
        switch self {
        case .divide, .multiply, .subtract, .add, .equal:
            return .orange
        default:
            return .darkGray
        }
    }
    var font: UIFont {
        return UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    var textColor: UIColor {
        return .white
    }
    var isDigit: Bool {
        return [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine].contains(self)
    }
    var isOperator: Bool {
        return [.add, .subtract, .multiply, .divide].contains(self)
    }
}

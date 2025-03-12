//
//  CalculatorTypes.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

enum CalculatorType: String, CaseIterable {
    case standard = "Стандартный"
    case scientific = "Научный"
    case notes = "Математические заметки"
    case conversion = "Конвертация"
    
    var iconName: String {
        switch self {
        case .standard: return "plus.forwardslash.minus"
        case .scientific: return "function"
        case .notes: return "sum"
        case .conversion: return "compass.drawing"
        }
    }
}

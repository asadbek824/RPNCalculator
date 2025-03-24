//
//  HomeWorker.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

final class HomeWorker {
    private let rpnService: RPNServiceProtocol
    
    init(rpnService: RPNServiceProtocol) {
        self.rpnService = rpnService
    }
}

extension HomeWorker {
    
    func evaluate(expression: [CalculatorButtonTypes]) -> String {
        
        let expressionString = expression.map { $0.rawValue }.joined()
        
        let evaluationResult = rpnService.evaluate(expression: expressionString)
        switch evaluationResult {
        case .success(let value):
            return value
        case .failure(let error):
            print("error \(error)")
            return "0"
        }
    }
    
    func updateExpression(
        with input: CalculatorButtonTypes,
        currentExpression: [CalculatorButtonTypes]
    ) -> [CalculatorButtonTypes] {
        
        var expression = currentExpression
        
        if expression == [.zero] && input != .dot && input != .closeBracket {
            switch input {
            case .subtract:
                return [.subtract]
            case .add, .multiply, .divide:
                return [.zero, input]
            default:
                return [input]
            }
        }
        
        if expression.count >= 2 {
            let last = expression.last!
            let secondLast = expression[expression.count - 2]
            if (secondLast == .openBracket || secondLast == .subtract) &&
                last == .zero && input.isDigit && input != .zero {
                expression.removeLast()
                expression.append(input)
                return expression
            }
        }
        
        switch input {
        case .closeBracket:
            
            let openCount = expression.filter { $0 == .openBracket }.count
            let closeCount = expression.filter { $0 == .closeBracket }.count
            
            if expression.isEmpty || closeCount >= openCount {
                return expression
            }
            if let last = expression.last, last.isOperator {
                return expression
            }
        case .openBracket:
            if let last = expression.last, last.isDigit || last == .closeBracket {
                return expression
            }
        case .add, .subtract, .multiply, .divide:
            
            if expression.isEmpty || expression.last == .openBracket {
                return expression
            }
            if let last = expression.last, last.isOperator {
                expression.removeLast()
                expression.append(input)
                return expression
            }
            
            expression.append(input)
            
            return expression
        case .dot:
            if expression.isEmpty || (expression.last?.isOperator ?? false) || expression.last == .openBracket {
                expression.append(.zero)
                expression.append(input)
                return expression
            }
            let components = expression.split { "+-×÷()".contains($0.rawValue) }
            if let lastComponent = components.last, lastComponent.contains(.dot) {
                return expression
            }
        default:
            break
        }
        
        expression.append(input)
        return expression
    }
}

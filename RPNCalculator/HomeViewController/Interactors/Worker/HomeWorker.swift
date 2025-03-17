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
    
    func evaluate(expression: String) -> String {
        return rpnService.evaluate(expression: expression)
    }
    
    func updateExpression(with input: String, currentExpression: String) -> String {
        var expression = currentExpression
        
        if expression == "0" && input != "." && input != ")" {
            if input == "-" {
                expression = "-"
                return expression
            }
            expression = ""
        }
        
        if (expression.hasSuffix("(0") || expression.hasSuffix("-0")),
           CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: input)),
           input != "0" {
            expression.removeLast()
            expression.append(input)
            return expression
        }
        
        switch (expression, input) {
        case (_, ")"):
            let openBrackets = expression.filter { $0 == "(" }.count
            let closeBrackets = expression.filter { $0 == ")" }.count
            if expression.isEmpty || closeBrackets >= openBrackets || "+-×÷".contains(expression.last ?? " ") {
                return expression
            }
        case (_, "("):
            if let lastChar = expression.last, lastChar.isNumber || lastChar == ")" {
                return expression
            }
        case (_, let op) where "+-×÷".contains(op):
            if expression.isEmpty || expression.last == "(" {
                return expression
            }
            if let last = expression.last, "+-×÷".contains(last) {
                expression.removeLast()
            }
            expression.append(input)
            return expression
        case (_, "."):
            let components = expression.split { "+-×÷()".contains($0) }
            if let lastComponent = components.last, lastComponent.contains(".") {
                return expression
            }
        default:
            break
        }
        
        expression.append(input)
        return expression
    }
}

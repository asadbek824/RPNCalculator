//
//  HomeWorker.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol RPNServiceProtocol {
    func evaluate(expression: String) -> String
}

final class RPNService {
    
    private func tokenize(_ expression: String) -> [String] {
        let pattern = "\\d+\\.?\\d*|[()+\\-*/]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        let nsRange = NSRange(expression.startIndex..<expression.endIndex, in: expression)
        let matches = regex.matches(in: expression, options: [], range: nsRange)
        
        let tokens = matches.compactMap { match -> String? in
            guard let range = Range(match.range, in: expression) else { return nil }
            return String(expression[range])
        }
        
        var processedTokens: [String] = []
        var previousToken: String? = nil
        for token in tokens {
            if token == "-" {
                if previousToken == nil || previousToken == "(" || "+-*/".contains(previousToken!) {
                    processedTokens.append("0")
                }
            }
            processedTokens.append(token)
            previousToken = token
        }
        return processedTokens
    }
    
    private func convertToRPN(_ expression: String) -> [String]? {
        let operatorPrecedence: [String: Int] = ["+": 1, "-": 1, "*": 2, "/": 2]
        var outputQueue: [String] = []
        var operatorStack: [String] = []
        
        let tokens = tokenize(expression)
        print("Tokens: \(tokens)")
        
        for token in tokens {
            if Double(token) != nil {
                outputQueue.append(token)
            } else if let tokenPrecedence = operatorPrecedence[token] {
                while let lastOperator = operatorStack.last,
                      let lastPrecedence = operatorPrecedence[lastOperator],
                      lastPrecedence >= tokenPrecedence {
                    outputQueue.append(operatorStack.removeLast())
                }
                operatorStack.append(token)
            } else if token == "(" {
                operatorStack.append(token)
            } else if token == ")" {
                while let lastOperator = operatorStack.last, lastOperator != "(" {
                    outputQueue.append(operatorStack.removeLast())
                }
                if operatorStack.last == "(" {
                    operatorStack.removeLast()
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        while let lastOperator = operatorStack.last {
            if lastOperator == "(" {
                return nil
            }
            outputQueue.append(operatorStack.removeLast())
        }
        return outputQueue
    }
    
    private func autoCorrectExpression(_ expression: String) -> String {
        var expr = expression
        let openBrackets = expr.filter { $0 == "(" }.count
        let closeBrackets = expr.filter { $0 == ")" }.count
        if openBrackets > closeBrackets {
            expr.append(String(repeating: ")", count: openBrackets - closeBrackets))
        }
        if let lastChar = expr.last, "+-*/×÷".contains(lastChar) {
            expr.removeLast()
        }
        return expr
    }
    
    private func evaluateRPN(_ tokens: [String]) -> String {
        var stack: [Double] = []
        
        for token in tokens {
            if let number = Double(token) {
                stack.append(number)
            } else {
                if stack.count >= 2 {
                    let b = stack.removeLast()
                    let a = stack.removeLast()
                    switch token {
                    case "+":
                        stack.append(a + b)
                    case "-":
                        stack.append(a - b)
                    case "*":
                        stack.append(a * b)
                    case "/":
                        stack.append(b == 0 ? 0 : a / b)
                    default:
                        continue
                    }
                } else {
                    continue
                }
            }
        }
        
        if let result = stack.last {
            if result.truncatingRemainder(dividingBy: 1) == 0 {
                return String(Int(result))
            } else {
                return String(result)
            }
        }
        return "0"
    }
}

//MARK: - RPNServiceProtocol
extension RPNService: RPNServiceProtocol {
    func evaluate(expression: String) -> String {
        let formattedExpression = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        if let rpnTokens = convertToRPN(formattedExpression) {
            print("RPN Expression: \(rpnTokens)")
            return evaluateRPN(rpnTokens)
        }
        
        let correctedExpression = autoCorrectExpression(formattedExpression)
        if let rpnTokens = convertToRPN(correctedExpression) {
            print("Auto-corrected RPN Expression: \(rpnTokens)")
            return evaluateRPN(rpnTokens)
        }
        return "0"
    }
}

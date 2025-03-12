//
//  HomeWorker.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

final class HomeWorker {
    
    func evaluate(expression: String) -> String {
        let formattedExpression = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        guard let rpnTokens = convertToRPN(formattedExpression) else { return "Error" }
        print("🔹 RPN Expression: \(rpnTokens)")
        
        let result = evaluateRPN(rpnTokens)
        return result
    }
    
    func updateExpression(with input: String, currentExpression: String) -> String {
        var expression = currentExpression
        
        if expression == "0" && input != "." {
            expression = ""
        }
        
        let operators = Set(["+", "-", "×", "÷"])
        let openBrackets = expression.filter { $0 == "(" }.count
        let closeBrackets = expression.filter { $0 == ")" }.count
        
        if input == ")" {
            if closeBrackets >= openBrackets {
                return expression
            }
        }
        
        if input == "(" {
            if let lastChar = expression.last, lastChar.isNumber {
                return expression
            }
        }
        
        if operators.contains(input) {
            if let lastChar = expression.last, operators.contains(String(lastChar)) {
                expression.removeLast()
            }
        }
        
        if input == "." {
            let components = expression.split(whereSeparator: { operators.contains(String($0)) })
            if let lastComponent = components.last, lastComponent.contains(".") {
                return expression
            }
        }
        
        expression.append(input)
        return expression
    }
    
    private func tokenize(_ expression: String) -> [String] {
        let pattern = "\\d+\\.?\\d*|[()+*/-]"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let matches = regex?.matches(in: expression, options: [], range: NSRange(location: 0, length: expression.utf16.count)) ?? []
        
        let tokens = matches.compactMap {
            Range($0.range, in: expression).map { String(expression[$0]) }
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
        let operators: [String: Int] = ["+": 1, "-": 1, "*": 2, "/": 2]
        var outputQueue: [String] = []
        var operatorStack: [String] = []
        
        let tokens = tokenize(expression)
        print("📌 Tokens: \(tokens)")
        
        var previousToken: String? = nil
        
        for token in tokens {
            if let _ = Double(token) {
                outputQueue.append(token)
            } else if operators.keys.contains(token) {
                if token == "-" && (previousToken == nil || previousToken == "(" || operators.keys.contains(previousToken!)) {
                    outputQueue.append("0")
                }
                while let lastOp = operatorStack.last,
                      let lastPrecedence = operators[lastOp],
                      let currentPrecedence = operators[token],
                      lastPrecedence >= currentPrecedence {
                    outputQueue.append(operatorStack.removeLast())
                }
                operatorStack.append(token)
            } else if token == "(" {
                operatorStack.append(token)
            } else if token == ")" {
                while let lastOp = operatorStack.last, lastOp != "(" {
                    outputQueue.append(operatorStack.removeLast())
                }
                if operatorStack.last == "(" {
                    operatorStack.removeLast()
                } else {
                    return nil
                }
            }
            previousToken = token
        }
        
        while let lastOp = operatorStack.last {
            if lastOp == "(" { return nil }
            outputQueue.append(operatorStack.removeLast())
        }
        
        return outputQueue
    }
    
    private func evaluateRPN(_ tokens: [String]) -> String {
        var stack: [Double] = []
        
        for token in tokens {
            print("📥 Processing token: \(token)")
            
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else { return "Error" }
                let b = stack.removeLast()
                let a = stack.removeLast()
                
                print("🧮 Calculating: \(a) \(token) \(b)")
                
                switch token {
                case "+": stack.append((a + b).rounded(toPlaces: 10))
                case "-": stack.append((a - b).rounded(toPlaces: 10))
                case "*": stack.append((a * b).rounded(toPlaces: 10))
                case "/": stack.append((a / b).rounded(toPlaces: 10))
                default: return "Error"
                }
            }
            print("📌 Stack after token: \(stack)")
        }
        
        return stack.count == 1 ? String(stack[0]) : "Error"
    }
}

//
//  HomeWorker.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol RPNServiceProtocol {
    func evaluate(expression: String) -> Result<String, CalculationError>
}

final class RPNService {
    
    // MARK: - Private Helpers
    private func autoCorrectExpression(_ expression: String) -> String {
        var expr = expression
        let openCount = expr.filter { $0 == "(" }.count
        let closeCount = expr.filter { $0 == ")" }.count
        if openCount > closeCount {
            expr.append(String(repeating: ")", count: openCount - closeCount))
        }
        if let lastChar = expr.last, "+-*/".contains(lastChar) {
            expr.removeLast()
        }
        return expr
    }
    
    private func tokenize(_ expression: String) -> [String] {
        let pattern = "\\d+\\.?\\d*|[()+\\-*/]"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let nsRange = NSRange(expression.startIndex..<expression.endIndex, in: expression)
        let matches = regex.matches(in: expression, range: nsRange)
        
        let tokens = matches.compactMap { match -> String? in
            guard let range = Range(match.range, in: expression) else { return nil }
            return String(expression[range])
        }
        
        var processedTokens: [String] = []
        for token in tokens {
            if token == "-" {
                if processedTokens.isEmpty ||
                    processedTokens.last == "(" ||
                    ["+", "-", "*", "/"].contains(processedTokens.last ?? "") {
                    processedTokens.append("0")
                }
            }
            processedTokens.append(token)
        }
        return processedTokens
    }
    
    private func convertToRPN(tokens: [String]) -> Result<[String], CalculationError> {
        let operatorPrecedence: [String: Int] = ["+": 1, "-": 1, "*": 2, "/": 2]
        var outputQueue: [String] = []
        var operatorStack: [String] = []
        
        for token in tokens {
            if Double(token) != nil {
                outputQueue.append(token)
            } else if let precedence = operatorPrecedence[token] {
                while let lastOperator = operatorStack.last,
                      let lastPrecedence = operatorPrecedence[lastOperator],
                      lastPrecedence >= precedence {
                    outputQueue.append(operatorStack.removeLast())
                }
                operatorStack.append(token)
            } else if token == "(" {
                operatorStack.append(token)
            } else if token == ")" {
                var foundOpeningParenthesis = false
                while let lastOperator = operatorStack.last {
                    if lastOperator == "(" {
                        operatorStack.removeLast()
                        foundOpeningParenthesis = true
                        break
                    } else {
                        outputQueue.append(operatorStack.removeLast())
                    }
                }
                if !foundOpeningParenthesis {
                    return .failure(.unmatchedParentheses)
                }
            } else {
                return .failure(.invalidExpression("Неожиданный токен: \(token)"))
            }
        }
        
        while let lastOperator = operatorStack.last {
            if lastOperator == "(" || lastOperator == ")" {
                return .failure(.unmatchedParentheses)
            }
            outputQueue.append(operatorStack.removeLast())
        }
        return .success(outputQueue)
    }
    
    private func evaluateRPN(tokens: [String]) -> Result<Double, CalculationError> {
        var stack: [Double] = []
        
        for token in tokens {
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else {
                    return .failure(.invalidExpression("Недостаточно операндов для оператора \(token)"))
                }
                let b = stack.removeLast()
                let a = stack.removeLast()
                var result: Double = 0
                switch token {
                case "+":
                    result = (a + b).rounded(toPlaces: 15)
                case "-":
                    result = (a - b).rounded(toPlaces: 15)
                case "*":
                    result = (a * b).rounded(toPlaces: 15)
                case "/":
                    if b == 0 {
                        return .failure(.divisionByZero)
                    }
                    result = (a / b).rounded(toPlaces: 15)
                default:
                    return .failure(.invalidExpression("Неизвестный оператор \(token)"))
                }
                stack.append(result)
            }
        }
        
        if stack.count != 1 {
            return .failure(.invalidExpression("Некорректное выражение"))
        }
        
        return .success(stack[0])
    }
}

// MARK: - RPNServiceProtocol
extension RPNService: RPNServiceProtocol {
    
    func evaluate(expression: String) -> Result<String, CalculationError> {
        let formattedExpression = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        let correctedExpression = autoCorrectExpression(formattedExpression)
        
        let digitsSet = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        if correctedExpression.trimmingCharacters(in: .whitespaces).isEmpty ||
            correctedExpression.rangeOfCharacter(from: digitsSet) == nil {
            return .success("0")
        }
        
        let tokens = tokenize(correctedExpression)
        let rpnResult = convertToRPN(tokens: tokens)
        
        switch rpnResult {
        case .failure(let error):
            return .failure(error)
        case .success(let rpnTokens):
            let evaluationResult = evaluateRPN(tokens: rpnTokens)
            switch evaluationResult {
            case .failure(let error):
                return .failure(error)
            case .success(let value):
                let formatted = (value.truncatingRemainder(dividingBy: 1) == 0)
                    ? String(Int(value))
                    : String(value)
                return .success(formatted)
            }
        }
    }
}


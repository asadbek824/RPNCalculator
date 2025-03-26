//
//  HomeInteractor.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol HomeBusseinessProtocol {
    func handleInput(_ input: CalculatorButtonTypes)
    func typesButtonTapped()
}

final class HomeInteractor {
    private let presenter: HomePresentationProtocol
    private let worker: HomeWorker
    private var currentExpression: [CalculatorButtonTypes] = [.zero]
    
    init(presenter: HomePresentationProtocol, worker: HomeWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension HomeInteractor: HomeBusseinessProtocol {
    func handleInput(_ input: CalculatorButtonTypes) {
        switch input {
        case .clear:
            currentExpression = [.zero]
        case .backspace:
            if !currentExpression.isEmpty {
                currentExpression.removeLast()
                if currentExpression.isEmpty {
                    currentExpression = [.zero]
                }
            }
        case .equal:
            let openBrackets = currentExpression.filter { $0 == .openBracket }.count
            let closeBrackets = currentExpression.filter { $0 == .closeBracket }.count
            
            if openBrackets > closeBrackets {
                let missing = openBrackets - closeBrackets
                for _ in 0..<missing {
                    currentExpression.append(.closeBracket)
                }
            }
            
            let resultString = worker.evaluate(expression: currentExpression)
            currentExpression = convertToExpressionArray(resultString)
        default:
            currentExpression = worker.updateExpression(with: input, currentExpression: currentExpression)
        }
        presenter.presentResult(expression: currentExpression)
    }
    
    func typesButtonTapped() {
        presenter.typesViewPresented()
    }
    
    private func convertToExpressionArray(_ result: String) -> [CalculatorButtonTypes] {
        if result.contains("e") {
            var array: [CalculatorButtonTypes] = []
            for character in result {
                let charStr = String(character)
                if charStr == "+" { continue }
                if let type = CalculatorButtonTypes(rawValue: charStr) {
                    array.append(type)
                }
            }
            return array
        } else {
            return result.compactMap { CalculatorButtonTypes(rawValue: String($0)) }
        }
    }
}

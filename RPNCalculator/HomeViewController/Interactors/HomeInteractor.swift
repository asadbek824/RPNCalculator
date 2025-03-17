//
//  HomeInteractor.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol HomeBusseinessProtocol {
    func handleInput(_ input: String)
    func typesButtonTapped()
}

final class HomeInteractor {
    private let presenter: HomePresentationProtocol
    private let worker: HomeWorker
    private var currentExpression: String = "0"
    
    init(presenter: HomePresentationProtocol, worker: HomeWorker) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension HomeInteractor: HomeBusseinessProtocol {
    func handleInput(_ input: String) {
        switch input {
        case "C":
            currentExpression = "0"
        case "⌫":
            if !currentExpression.isEmpty {
                currentExpression.removeLast()
                if currentExpression.isEmpty {
                    currentExpression = "0"
                }
            }
        case "=":
            let openBrackets = currentExpression.filter { $0 == "(" }.count
            let closeBrackets = currentExpression.filter { $0 == ")" }.count
            if openBrackets > closeBrackets {
                currentExpression.append(String(repeating: ")", count: openBrackets - closeBrackets))
            }
            let result = worker.evaluate(expression: currentExpression)
            currentExpression = result
        default:
            currentExpression = worker.updateExpression(with: input, currentExpression: currentExpression)
        }
        presenter.presentResult(expression: currentExpression)
    }
    
    func typesButtonTapped() {
        presenter.typesViewPresented()
    }
}

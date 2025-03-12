//
//  HomeInteractor.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol HomeBusseinessProtocol {
    func handleInput(_ input: String)
}

final class HomeInteractor: HomeBusseinessProtocol {
    
    var presenter: HomePresentationProtocol
    private let worker = HomeWorker()
    
    private var currentExpression: String = "0"
    
    init(presenter: HomePresentationProtocol) {
        self.presenter = presenter
    }
    
    func handleInput(_ input: String) {
        switch input {
        case  "C": currentExpression = "0"
        case "⌫":
            if !currentExpression.isEmpty {
                currentExpression.removeLast()
                if currentExpression.isEmpty {
                    currentExpression = "0"
                }
            }
        case "=":
            let result = worker.evaluate(expression: currentExpression)
            currentExpression = result
        default:
            currentExpression = worker.updateExpression(with: input, currentExpression: currentExpression)
        }
        presenter.presentResult(expression: currentExpression)
    }
}

//
//  HomePresenter.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol HomePresentationProtocol {
    func presentResult(expression: [CalculatorButtonTypes])
    func typesViewPresented()
}

final class HomePresenter {
    weak var view: HomeViewDisplayProtocol?
}

extension HomePresenter: HomePresentationProtocol {
    func presentResult(expression: [CalculatorButtonTypes]) {
        view?.displayResult(expression)
    }
    
    func typesViewPresented() {
        view?.showTypesScreen()
    }
}

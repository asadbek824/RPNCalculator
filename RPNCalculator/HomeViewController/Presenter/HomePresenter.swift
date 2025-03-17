//
//  HomePresenter.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol HomePresentationProtocol {
    func presentResult(expression: String)
    func typesViewPresented()
}

final class HomePresenter {
    weak var view: HomeViewDisplayProtocol?
}

extension HomePresenter: HomePresentationProtocol {
    func presentResult(expression: String) {
        view?.displayResult(expression)
    }
    
    func typesViewPresented() {
        view?.showTypesScreen()
    }
}

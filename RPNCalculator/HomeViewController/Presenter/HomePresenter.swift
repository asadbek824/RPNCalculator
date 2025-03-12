//
//  HomePresenter.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol HomePresentationProtocol {
    func presentResult(expression: String)
}

final class HomePresenter: HomePresentationProtocol {
    
    weak var view: HomeViewDisplayProtocol?
    
    func presentResult(expression: String) {
        view?.displayResult(expression)
    }    
}

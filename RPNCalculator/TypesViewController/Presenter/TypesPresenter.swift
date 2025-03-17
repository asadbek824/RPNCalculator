//
//  TypesPresenter.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol TypesPresentationProtocol {
    func closeTypesView()
    func updateSelectedType(_ type: CalculatorType)
    func featchSelectedType(_ selectedType: CalculatorType)
}

final class TypesPresenter {
    
    weak var view: TypesDisplayProtocol?
    
}

//MARK: - TypesPresentationProtocol
extension TypesPresenter: TypesPresentationProtocol {
    
    func closeTypesView() {
        view?.closeTypesView()
    }
    
    func updateSelectedType(_ type: CalculatorType) {
        view?.displayTypes(CalculatorType.allCases, selectedType: type)
    }
    
    func featchSelectedType(_ selectedType: CalculatorType) {
        view?.displayTypes(CalculatorType.allCases, selectedType: selectedType)
    }
}

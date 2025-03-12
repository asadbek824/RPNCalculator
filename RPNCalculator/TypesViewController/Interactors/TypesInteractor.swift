//
//  TypesInteractor.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol TypesBussenesProtocol {
    func viewTapped()
    func selectNewType(_ type: CalculatorType)
    func featchTypes()
}

final class TypesInteractor: TypesBussenesProtocol {
    
    var presenter: TypesPresentationProtocol
    private let worker = TypesWorker()
    
    init(presenter: TypesPresentationProtocol) {
        self.presenter = presenter
    }
    
    func viewTapped() {
        presenter.closeTypesView()
    }
    
    func selectNewType(_ type: CalculatorType) {
        worker.saveType(type)
        presenter.updateSelectedType(type)
        presenter.closeTypesView()
    }
    
    func featchTypes() {
        let selectedType = worker.getType()
        presenter.featchSelectedType(selectedType)
    }
}

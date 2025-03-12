//
//  TypesWorker.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

protocol TypesWorkerProtocol {
    func getType() -> CalculatorType
    func saveType(_ type: CalculatorType)
}

final class TypesWorker: TypesWorkerProtocol {
    
    private let selectedTypeKey = "selectedCalculatorType"
    
    func getType() -> CalculatorType {
        if let savedTypeRawValue = UserDefaults.standard.string(forKey: selectedTypeKey),
           let savedType = CalculatorType(rawValue: savedTypeRawValue) {
            return savedType
        }
        return .standard
    }
    
    func saveType(_ type: CalculatorType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: selectedTypeKey)
    }
}

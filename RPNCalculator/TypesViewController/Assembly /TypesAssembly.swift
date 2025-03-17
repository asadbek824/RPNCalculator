//
//  TypesAssembly.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

final class TypesAssembly {
    
    static func assemble() -> TypesViewController {
        
        let preseter = TypesPresenter()
        let router = TypesRouter()
        let worker = TypesWorker()
        let interactor = TypesInteractor(presenter: preseter, worker: worker)
        
        let viewController = TypesViewController(interactor: interactor, router: router)
        
        preseter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}

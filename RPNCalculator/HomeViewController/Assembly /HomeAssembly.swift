//
//  HomeAssembly.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

final class HomeAssembly {
    
    static func assemble() -> HomeViewController {
        
        let router = HomeRouter()
        let presenter = HomePresenter()
        let interactor = HomeInteractor(presenter: presenter)
        
        let viewController = HomeViewController(interactor: interactor, router: router)
        
        presenter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
    
    
}

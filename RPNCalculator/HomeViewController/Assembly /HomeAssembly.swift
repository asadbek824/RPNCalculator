//
//  HomeAssembly.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import Foundation

final class HomeAssembly {
    
    static func assemble() -> HomeViewController {
        
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter()
        
        let viewController = HomeViewController(interactor: interactor, router: router)
        
        presenter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}

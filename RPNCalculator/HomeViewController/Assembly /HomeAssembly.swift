//
//  HomeAssembly.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

final class HomeAssembly: AnyObject {
    protocol Dependencies: AnyObject {
        var rpnService: RPNService { get }
    }
    
    static func assemble(dependencies: Dependencies? = nil) -> HomeViewController {
        
        let router = HomeRouter()
        let presenter = HomePresenter()
        let worker = HomeWorker(rpnService: dependencies?.rpnService ?? RPNService())
        let interactor = HomeInteractor(presenter: presenter, worker: worker)
        
        let viewController = HomeViewController(interactor: interactor, router: router)
        
        presenter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}

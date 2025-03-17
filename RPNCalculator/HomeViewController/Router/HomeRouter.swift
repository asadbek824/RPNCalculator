//
//  HomeRouter.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

protocol HomeRoutingProtocol {
    func navigateToTypes()
}

final class HomeRouter {
    
    weak var viewController: UIViewController?
    
}

//MARK: - HomeRoutingProtocol
extension HomeRouter: HomeRoutingProtocol {
    
    func navigateToTypes() {
        guard let viewController = viewController else { return }
        
        let typesViewController = TypesAssembly.assemble()
        typesViewController.modalPresentationStyle = .overFullScreen
        viewController.present(typesViewController, animated: false)
    }
}

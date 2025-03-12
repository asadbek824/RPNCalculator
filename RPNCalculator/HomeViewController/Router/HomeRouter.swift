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

final class HomeRouter: HomeRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func navigateToTypes() {
        guard let viewController = viewController else { return }
        
        let typesViewController = TypesAssembly.assemble()
        typesViewController.modalPresentationStyle = .overFullScreen
        viewController.present(typesViewController, animated: false)
    }
}

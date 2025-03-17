//
//  TypesRouter.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

protocol TypesRoutingProtocol {
    func routeToHome()
}
 
final class TypesRouter {
    
    weak var viewController: UIViewController?
    
}

//MARK: - TypesRoutingProtocol
extension TypesRouter: TypesRoutingProtocol {
    
    func routeToHome() {
        viewController?.dismiss(animated: false)
    }
}

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
 
final class TypesRouter: TypesRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func routeToHome() {
        viewController?.dismiss(animated: false)
    }
}

//
//  MockView.swift
//  RPNCalculatorTests
//
//  Created by Asadbek Yoldoshev on 3/24/25.
//

import XCTest
@testable import RPNCalculator

final class MockView: HomeViewDisplayProtocol {
    var displayedResult: [CalculatorButtonTypes]?
    var didShowTypesScreen = false
    
    func displayResult(_ result: [CalculatorButtonTypes]) {
        displayedResult = result
    }
    
    func showTypesScreen() {
        didShowTypesScreen = true
    }
}

final class MockRouter: HomeRoutingProtocol {
    var didNavigateToTypes = false
    weak var viewController: UIViewController?

    func navigateToTypes() {
        didNavigateToTypes = true
    }
}

final class MockRPNService: RPNServiceProtocol {
    var evaluateResult: Result<String, CalculationError> = .success("0")
    
    func evaluate(expression: String) -> Result<String, CalculationError> {
        return evaluateResult
    }
}

final class HomeModuleTests: XCTestCase {
    
    func testCalculationFlow() {
        let mockRPNService = MockRPNService()
        mockRPNService.evaluateResult = .success("14")
        
        let worker = HomeWorker(rpnService: mockRPNService)
        let presenter = HomePresenter()
        let mockView = MockView()
        presenter.view = mockView
        let interactor = HomeInteractor(presenter: presenter, worker: worker)
        
        interactor.handleInput(.seven)
        interactor.handleInput(.add)
        interactor.handleInput(.seven)
        interactor.handleInput(.equal)
        
        let expectedResult: [CalculatorButtonTypes] = [.one, .four]
        XCTAssertEqual(mockView.displayedResult, expectedResult, "Результат вычисления должен быть равен 14")
    }
    
    func testRouterNavigation() {
        let mockRouter = MockRouter()
        let mockRPNService = MockRPNService()
        let worker = HomeWorker(rpnService: mockRPNService)
        let presenter = HomePresenter()
        let interactor = HomeInteractor(presenter: presenter, worker: worker)
        let homeVC = HomeViewController(interactor: interactor, router: mockRouter)
        presenter.view = homeVC
        mockRouter.viewController = homeVC
        
//        homeVC.perform(#selector(HomeViewController.typesButtonTapped))
        
        XCTAssertTrue(mockRouter.didNavigateToTypes, "Должна быть вызвана навигация к экрану типов")
    }
}

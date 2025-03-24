//
//  ViewController.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

protocol HomeViewDisplayProtocol: AnyObject {
    func displayResult(_ result: [CalculatorButtonTypes])
    func showTypesScreen()
}

final class HomeViewController: UIViewController {
    
    private let interactor: HomeBusseinessProtocol
    private let router: HomeRoutingProtocol
    
    private let displayScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 48, weight: .light)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let typesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        button.tintColor = .orange
        return button
    }()
    
    private let buttonTitlesVertical: [[CalculatorButtonTypes]] = [
        [.clear, .backspace, .openBracket, .closeBracket],
        [.seven, .eight, .nine, .divide],
        [.four, .five, .six, .multiply],
        [.one, .two, .three, .subtract],
        [.zero, .dot, .equal, .add]
    ]
    private let buttonTitlesHorizontal: [[CalculatorButtonTypes]] = [
        [.seven, .eight, .nine, .openBracket, .divide],
        [.four, .five, .six, .closeBracket, .multiply],
        [.one, .two, .three, .backspace, .subtract],
        [.clear, .zero, .dot, .equal, .add]
    ]
    private var buttonSquareConstraints = [NSLayoutConstraint]()
    
    init(interactor: HomeBusseinessProtocol, router: HomeRoutingProtocol) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let isLandscape = size.width > size.height
        
        coordinator.animate(alongsideTransition: { _ in
            self.buttonSquareConstraints.forEach { $0.isActive = !isLandscape }
            self.view.layoutIfNeeded()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetUpView
private extension HomeViewController {
    func setUpView() {
        view.backgroundColor = .black
        setUpTypesButton()
        setUpMainStackView()
    }
    
    func setUpTypesButton() {
        view.addSubview(typesButton)
        
        typesButton.setConstraint(.left, from: view, 20)
        typesButton.setConstraint(.width, from: view, 40)
        typesButton.setConstraint(.height, from: view, 50)
        typesButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 20
        ).isActive = true
        
        typesButton.addTarget(self, action: #selector(typesButtonTapped), for: .touchUpInside)
    }
    
    func setUpMainStackView() {
        view.addSubview(mainStackView)
        
        mainStackView.setConstraint(.left, from: view, 20)
        mainStackView.setConstraint(.right, from: view, 20)
        mainStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -10
        ).isActive = true
        
        mainStackView.addArrangedSubview(displayScrollView)
        
        displayScrollView.addSubview(displayLabel)
        displayLabel.setConstraint(.right, from: displayScrollView, 0)
        displayLabel.setConstraint(.top, from: displayScrollView, 0)
        displayLabel.setConstraint(.bottom, from: displayScrollView, 0)
        displayLabel.heightAnchor.constraint(
            equalTo: displayScrollView.heightAnchor
        ).isActive = true
        displayLabel.widthAnchor.constraint(
            greaterThanOrEqualTo: displayScrollView.widthAnchor
        ).isActive = true
        displayLabel.leadingAnchor.constraint(
            greaterThanOrEqualTo: displayScrollView.leadingAnchor
        ).isActive = true
        
        setUpCalculatorButtons()
    }
    
    func setUpCalculatorButtons() {
        for row in buttonTitlesVertical {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            
            for calculatorButton in row {
                let button = CalculatorButton(type: .system)
                button.customType = calculatorButton
                button.addTarget(self, action: #selector(calculatorButtonTapped), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                let squareConstraint = button.heightAnchor.constraint(equalTo: button.widthAnchor)
                squareConstraint.isActive = true
                buttonSquareConstraints.append(squareConstraint)
                rowStackView.addArrangedSubview(button)
            }
            mainStackView.addArrangedSubview(rowStackView)
        }
    }
}

//MARK: - @Objc Functions
private extension HomeViewController {
    @objc func calculatorButtonTapped(_ sender: CalculatorButton) {
        guard let customType = sender.customType else { return }
        interactor.handleInput(customType)
    }
    
    @objc func typesButtonTapped() {
        interactor.typesButtonTapped()
    }
}

//MARK: - HomeViewDisplayProtocol
extension HomeViewController: HomeViewDisplayProtocol {
    func displayResult(_ result: [CalculatorButtonTypes]) {
        
        let resultText = result.map { $0.rawValue }.joined()
        displayLabel.text = resultText
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let labelWidth = self.displayLabel.intrinsicContentSize.width
            let scrollViewWidth = self.displayScrollView.frame.width
            self.displayScrollView.contentSize = CGSize(width: labelWidth, height: self.displayScrollView.frame.height)
            if labelWidth > scrollViewWidth {
                let offsetX = max(labelWidth - scrollViewWidth, 0)
                self.displayScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        }
    }
    
    func showTypesScreen() {
        router.navigateToTypes()
    }
}

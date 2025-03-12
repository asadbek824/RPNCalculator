//
//  ViewController.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

protocol HomeViewDisplayProtocol: AnyObject {
    func displayResult(_ result: String)
    func showTypesScreen()
}

final class HomeViewController: UIViewController {
    
    var interactor: HomeBusseinessProtocol
    var router: HomeRoutingProtocol
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 48, weight: .light)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .fill
        mainStackView.distribution  = .fillEqually
        return mainStackView
    }()
    private let typesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "line.3.horizontal.decrease.circle"),
            for: .normal
        )
        button.tintColor = .orange
        return button
    }()
    
    private let buttonTitles: [[String]] = [
        ["C", "⌫", "(", ")"],
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]
    
    init(interactor: HomeBusseinessProtocol, router: HomeRoutingProtocol) {
        self.interactor = interactor
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
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
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20
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
        
        mainStackView.addArrangedSubview(displayLabel)
        
        displayLabel.setConstraint(.height, from: mainStackView, 80)
        
        setUpCalculatorButtons()
    }
    
    func setUpCalculatorButtons() {
        for row in buttonTitles {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            
            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = ["÷", "×", "-", "+", "="].contains(title) ? .orange : .darkGray
                button.tag = title.hash
                button.addTarget(self, action: #selector(calculatorButtonTapped), for: .touchUpInside)
                
                rowStackView.addArrangedSubview(button)
                
                DispatchQueue.main.async {
                    button.layer.cornerRadius = button.frame.height / 2
                    button.layer.masksToBounds = true
                }
            }
            mainStackView.addArrangedSubview(rowStackView)
        }
    }
}

//MARK: - @OBJC Functions
private extension HomeViewController {
    
    @objc func calculatorButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        interactor.handleInput(title)
    }
    
    @objc func typesButtonTapped() {
        interactor.typesButtonTapped()
    }
}

//MARK: - HomeViewDisplayProtocol
extension HomeViewController: HomeViewDisplayProtocol {
  
    func displayResult(_ result: String) {
        if result.hasSuffix(".") {
            displayLabel.text = result
            return
        }
        
        if let number = Double(result) {
            let intValue = Int(number)
            displayLabel.text = (number == Double(intValue)) ? "\(intValue)" : "\(number)"
        } else {
            displayLabel.text = result
        }
    }
    
    func showTypesScreen() {
        router.navigateToTypes()
    }
}


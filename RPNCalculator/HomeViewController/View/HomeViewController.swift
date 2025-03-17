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
        typesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        typesButton.addTarget(self, action: #selector(typesButtonTapped), for: .touchUpInside)
    }
    
    func setUpMainStackView() {
        view.addSubview(mainStackView)
        
        mainStackView.setConstraint(.left, from: view, 20)
        mainStackView.setConstraint(.right, from: view, 20)
        mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        mainStackView.addArrangedSubview(displayScrollView)
        displayScrollView.setConstraint(.height, from: mainStackView, 80)
        
        displayScrollView.addSubview(displayLabel)
        displayLabel.setConstraint(.right, from: displayScrollView, 0)
        displayLabel.leadingAnchor.constraint(greaterThanOrEqualTo: displayScrollView.leadingAnchor).isActive = true
        displayLabel.setConstraint(.top, from: displayScrollView, 0)
        displayLabel.setConstraint(.bottom, from: displayScrollView, 0)
        displayLabel.heightAnchor.constraint(equalTo: displayScrollView.heightAnchor).isActive = true
        displayLabel.widthAnchor.constraint(greaterThanOrEqualTo: displayScrollView.widthAnchor).isActive = true
        
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

//MARK: - @Objc Functions
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
        
        displayLabel.text = result
        
        DispatchQueue.main.async {
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

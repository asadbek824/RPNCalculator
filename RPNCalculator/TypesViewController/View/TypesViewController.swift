//
//  TypesViewController.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

protocol TypesDisplayProtocol: AnyObject {
    func closeTypesView()
    func displayTypes(_ types: [CalculatorType], selectedType: CalculatorType)
}

final class TypesViewController: UIViewController {
    
    private let interactor: TypesBussenesProtocol
    private let router: TypesRoutingProtocol
    
    private let tableView = UITableView()
    private let backgroundView = UIView()
    
    private var calculatorTypes = CalculatorType.allCases
    private var selectedType: CalculatorType = .standard
    
    init(interactor: TypesBussenesProtocol, router: TypesRoutingProtocol) {
        self.interactor = interactor
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.featchTypes()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations:
                { [weak self] in
                    guard let self else { return }
                    self.tableView.alpha = 1
                }
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetUpView
private extension TypesViewController {
    
    func setUpView() {
        
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        
        backgroundView.backgroundColor = .clear
        
        backgroundView.setConstraint(.left, from: view, 0)
        backgroundView.setConstraint(.right, from: view, 0)
        backgroundView.setConstraint(.top, from: view, 0)
        backgroundView.setConstraint(.bottom, from: view, 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
        
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TypesTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        
        tableView.setConstraint(.left, from: view, 40)
        tableView.setConstraint(.right, from: view, 100)
        tableView.setConstraint(.height, from: view, CGFloat(calculatorTypes.count * 44))
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        
        tableView.layer.shadowColor = UIColor.white.cgColor
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 10
        tableView.layer.masksToBounds = false
        tableView.alpha = 0
    }
}

//MARK: - @OBJC Functions
private extension TypesViewController {
    
    @objc func viewTapped() {
        interactor.viewTapped()
    }
}

//MARK: - TypesDisplayProtocol
extension TypesViewController: TypesDisplayProtocol {
    
    func closeTypesView() {
        let cells = tableView.visibleCells
        
        for (index, cell) in cells.enumerated() {
            UIView.animate(
                withDuration: 0.3,
                delay: 0.05 * Double(index),
                options: .curveEaseInOut,
                animations:
                    { [weak self, cell] in
                        guard let self else { return }
                        cell.alpha = 0
                        cell.transform = CGAffineTransform(translationX: 0, y: -50)
                        self.tableView.alpha = 0
                    }
            ) { _ in
                if index == cells.count - 1 {
                    self.router.routeToHome()
                }
            }
        }
    }
    
    func displayTypes(_ types: [CalculatorType], selectedType: CalculatorType) {
        self.calculatorTypes = types
        self.selectedType = selectedType
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension TypesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculatorTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TypesTableViewCell else { return UITableViewCell() }
        
        let type = calculatorTypes[indexPath.row]
        
        cell.configure(with: type, isSelected: type == selectedType)
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0.05 * Double(indexPath.row),
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations:
                { [weak cell] in
                    guard let cell = cell else { return }
                    cell.alpha = 1
                    cell.transform = .identity
                }
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newType = calculatorTypes[indexPath.row]
        interactor.selectNewType(newType)
    }
}

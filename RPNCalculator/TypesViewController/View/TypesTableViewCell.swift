//
//  TypesTableViewCell.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/12/25.
//

import UIKit

final class TypesTableViewCell: UITableViewCell {
    
    private let typeImageView = UIImageView()
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
    }
    
    func configure(with type: CalculatorType, isSelected: Bool) {
        typeLabel.text = type.rawValue
        typeImageView.image = UIImage(systemName: type.iconName)
        let color: UIColor = isSelected ? .orange : .black
        typeLabel.textColor = color
        typeImageView.tintColor = color
    }
    
    private func setupView() {
        addSubview(typeImageView)
        addSubview(typeLabel)
        
        typeImageView.setConstraint(.left, from: self, 10)
        typeImageView.setConstraint(.yCenter, from: self, 0)
        typeImageView.setConstraint(.width, from: self, 24)
        typeImageView.setConstraint(.height, from: self, 24)
        typeLabel.setConstraint(.yCenter, from: self, 0)
        typeLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

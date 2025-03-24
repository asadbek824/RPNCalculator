//
//  CalculatorButton.swift
//  RPNCalculator
//
//  Created by Asadbek Yoldoshev on 3/19/25.
//

import UIKit

final class CalculatorButton: UIButton {
    
    var customType: CalculatorButtonTypes? {
        didSet {
            guard let type = customType else { return }
            setTitle(type.title, for: .normal)
            titleLabel?.font = type.font
            setTitleColor(type.textColor, for: .normal)
            backgroundColor = type.backgroundColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

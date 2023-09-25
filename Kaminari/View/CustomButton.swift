//
//  CustomButton.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import UIKit

final class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, fontSize: CGFloat, font: UIFont.Weight) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: fontSize, weight: font)
    }
    
    func setupButtonUI(cornerValue: CGFloat, background: UIColor, fontColor: UIColor) {
        self.layer.cornerRadius = cornerValue
        self.backgroundColor = background
        self.setTitleColor(fontColor, for: .normal)
    }
}


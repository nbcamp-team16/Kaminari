//
//  CustomLabel.swift
//  Kaminari
//
//  Created by 이수현 on 2023/09/26.
//

import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, fontSize: CGFloat, font: UIFont.Weight) {
        self.text = text
        self.font = .systemFont(ofSize: fontSize, weight: font)
    }

    func setupLabelUI(fontColor: UIColor) {
        self.textColor = fontColor
    }
}

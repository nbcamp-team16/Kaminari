//
//  CustomStackView.swift
//  ToDoApp_MVVM
//
//  Created by (^ㅗ^)7 Macbook pro  on 2023/09/20.
//

import UIKit

class CustomStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(axis: NSLayoutConstraint.Axis, alignment: Alignment, distribution: Distribution, spacing: CGFloat) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}

//
//  CurrentTimelyCell.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import UIKit

class CurrentTimelyCell: UICollectionViewCell {
    static let identifier = "CurrentTimelyCell"
}

extension CurrentTimelyCell {
    func setupShadow(color: CGColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

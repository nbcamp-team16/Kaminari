//
//  CustomCollectionView.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/26.
//

import UIKit

class CustomCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionView {
    func configureSectionItemSize(widthDimension: NSCollectionLayoutDimension, heightDimension: NSCollectionLayoutDimension) -> NSCollectionLayoutSize {
        let itemSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
        return itemSize
    }

    func configureSectionItem(layoutSize: NSCollectionLayoutSize) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        return item
    }
    
    func configureContentInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> NSDirectionalEdgeInsets {
        let item = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        return item
    }
}

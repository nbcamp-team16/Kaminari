//
//  CustomCollectionFooterView.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/27.
//

import SnapKit
import UIKit

class CustomCollectionFooterView: UICollectionReusableView {
    static let identifier = "CustomCollectionFooterView"

    var lineView = UIView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionFooterView {
    func setupHeaderUI() {
        setupLineView()
    }

    func setupLineView() {
        addSubview(lineView)
        lineView.backgroundColor = .black

        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

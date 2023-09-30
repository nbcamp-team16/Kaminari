//
//  CustomCollectionHeaderView.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/27.
//

import SnapKit
import UIKit

class CustomCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CustomCollectionHeaderView"

    var titleLabel = CustomLabel(frame: .zero)
    var lineView = UIView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionHeaderView {
    func setupTotalUI(title: String) {
        setupTitleLabel(title: title)
        setupLineView()
    }

    func setupTitleLabel(title: String) {
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.setupLabelColor(color: .systemBackground)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
    }

    func setupLineView() {
        addSubview(lineView)
        lineView.backgroundColor = .systemBackground

        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(0.5)
        }
    }
}

// extension CustomCollectionHeaderView {
//    func setupSingleLine() {
//        addSubview(lineView)
//        lineView.backgroundColor = .black
//
//        lineView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.width.equalToSuperview().inset(5)
//            make.height.equalTo(0.5)
//        }
//    }
// }

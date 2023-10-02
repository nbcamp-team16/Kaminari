//
//  CurrentWeatherCell.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

class CurrentWeatherCell: UICollectionViewCell {
    static let identifier = "CurrentWeatherCell"

    var superStackView = CustomStackView(frame: .zero)
    var currentWeatherLabel = CustomLabel(frame: .zero)
    var currentTemperatureLabel = CustomLabel(frame: .zero)
    var currentDescriptionLabel = CustomLabel(frame: .zero)
}

extension CurrentWeatherCell {
    func setupUI() {
        setupSuperStackView()
        setupWeatherLabel()
        setupTemperatureLabel()
        setupDescriptionLabel()
    }
}

extension CurrentWeatherCell {
    func setupSuperStackView() {
        contentView.addSubview(superStackView)
        superStackView.configure(axis: .vertical, alignment: .leading, distribution: .fillProportionally, spacing: 0)

        [currentWeatherLabel, currentTemperatureLabel, currentDescriptionLabel].forEach {
            superStackView.addArrangedSubview($0)
        }

        superStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
    }

    func setupWeatherLabel() {
        currentWeatherLabel.font = .systemFont(ofSize: 18, weight: .bold)
        currentWeatherLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(5)
            make.height.equalTo(30)
        }
    }

    func setupTemperatureLabel() {
        currentTemperatureLabel.font = .systemFont(ofSize: 22, weight: .bold)
        currentTemperatureLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.height.equalTo(80)
        }
    }

    func setupDescriptionLabel() {
        currentDescriptionLabel.adjustsFontSizeToFitWidth = true
        currentDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        currentDescriptionLabel.numberOfLines = 3
        currentDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }
}

extension CurrentWeatherCell {
    func setupShadow(color: CGColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

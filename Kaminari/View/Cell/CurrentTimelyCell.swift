//
//  CurrentTimelyCell.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

class CurrentTimelyCell: UICollectionViewCell {
    static let identifier = "CurrentTimelyCell"

    var superStackView = CustomStackView(frame: .zero)
    var timeLabel = CustomLabel(frame: .zero)
    var temperatureLabel = CustomLabel(frame: .zero)
    var weatherIconImageView = CustomImageView(frame: .zero)
}

extension CurrentTimelyCell {
    func setupUI() {
        setupSuperStackView()
        setupTimeLabel()
        setupTemperatureLabel()
        setupWeatherLabel()
    }
}

extension CurrentTimelyCell {
    func setupSuperStackView() {
        contentView.addSubview(superStackView)
        superStackView.configure(axis: .vertical, alignment: .center, distribution: .fillEqually, spacing: 0)
        [timeLabel, temperatureLabel, weatherIconImageView].forEach {
            superStackView.addArrangedSubview($0)
        }

        superStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
    }

    func setupTimeLabel() {
        superStackView.addSubview(timeLabel)
        timeLabel.font = .systemFont(ofSize: 18, weight: .bold)
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }

    func setupTemperatureLabel() {
        superStackView.addSubview(temperatureLabel)
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        temperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }

    func setupWeatherLabel() {
        superStackView.addSubview(weatherIconImageView)
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
}

extension CurrentTimelyCell {
    func setupShadow(color: CGColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

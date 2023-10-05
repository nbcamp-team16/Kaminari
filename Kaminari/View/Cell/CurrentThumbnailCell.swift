//
//  CurrentThumbnailCell.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import Gifu
import SnapKit
import UIKit

class CurrentThumbnailCell: UICollectionViewCell {
    static let identifier = "CurrentThumbnailCell"

    var superStackView = CustomStackView(frame: .zero)
    var bottomHStackView = CustomStackView(frame: .zero)
    var bottomVStackView = CustomStackView(frame: .zero)

    var topSuperView = UIView(frame: .zero)
    var bottomSuperView = UIView(frame: .zero)

    var currentDateLabel = CustomLabel(frame: .zero)
    var currentCityNameLabel = CustomLabel(frame: .zero)
    var currentTemperatureLabel = CustomLabel(frame: .zero)

    var currentWeatherIconImage = CustomImageView(frame: .zero)
}

extension CurrentThumbnailCell {
    func setupUI() {
        setupSuperStackView()
        setupTopView()
        setupBottomView()
    }
}

extension CurrentThumbnailCell {
    func setupSuperStackView() {
        contentView.addSubview(superStackView)
        superStackView.configure(axis: .vertical, alignment: .fill, distribution: .fillProportionally, spacing: 0)
        [topSuperView, bottomSuperView].forEach {
            superStackView.addArrangedSubview($0)
        }

        superStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    func setupTopView() {
        topSuperView.addSubview(currentWeatherIconImage)
        topSuperView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }

        setupWeatherIcon()
    }

    func setupBottomView() {
        bottomSuperView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }

        setupBottomHStackView()
        setupBottomVStackView()
    }
}

extension CurrentThumbnailCell {
    func setupBottomHStackView() {
        bottomSuperView.addSubview(bottomHStackView)
        bottomSuperView.layer.cornerRadius = 10
        bottomSuperView.backgroundColor = .systemBackground
        bottomHStackView.configure(axis: .horizontal, alignment: .fill, distribution: .fillProportionally, spacing: 0)
        [bottomVStackView, currentTemperatureLabel].forEach {
            bottomHStackView.addArrangedSubview($0)
        }

        bottomHStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }

        setupTemperature()
    }

    func setupBottomVStackView() {
        bottomHStackView.addSubview(bottomVStackView)
        bottomVStackView.configure(axis: .vertical, alignment: .leading, distribution: .fillProportionally, spacing: 0)
        [currentDateLabel, currentCityNameLabel].forEach {
            bottomVStackView.addArrangedSubview($0)
        }

        bottomVStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.width.equalTo(150)
        }

        setupDateLabel()
        setupCityLabel()
    }
}

extension CurrentThumbnailCell {
    func setupWeatherIcon() {
        currentWeatherIconImage.contentMode = .scaleAspectFit
        currentWeatherIconImage.tintColor = .label
        currentWeatherIconImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-30)
        }
    }

    func setupDateLabel() {
        currentDateLabel.text = "현재날씨"
        currentDateLabel.setupLabelColor(color: .label)
        currentDateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        currentDateLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }

    func setupCityLabel() {
        currentCityNameLabel.setupLabelColor(color: .label)
        currentCityNameLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        currentCityNameLabel.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
    }

    func setupTemperature() {
        currentTemperatureLabel.setupLabelColor(color: .label)
        currentTemperatureLabel.font = .systemFont(ofSize: 40, weight: .bold)
        currentTemperatureLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
    }
}

extension CurrentThumbnailCell {
    func setupShadow(color: CGColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

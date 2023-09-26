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

    var topTagView = UIView(frame: .zero)
    var bottomTagView = UIView(frame: .zero)

    var dateLabel = CustomLabel(frame: .zero)
    var currentCityNameLabel = CustomLabel(frame: .zero)
    var currentWeatherLabel = CustomLabel(frame: .zero)
    var currentTemperatureLabel = CustomLabel(frame: .zero)

    var currentWeatherGIFImage = GIFImageView(frame: .zero)
    var currentWeatherIconImage = CustomImageView(frame: .zero)

    var refreshButton = CustomButton(frame: .zero)
}

// MARK: - UI

extension CurrentThumbnailCell {
    func setupUI() {
        setupGIFImageView()
        setupTagView()
        setupBottomTagViewUI()
    }

    func configureCell(data: CurrentWeatherMockup, size: CGFloat, font: UIFont.Weight) {
        currentCityNameLabel.text = data.location
        currentCityNameLabel.font = .systemFont(ofSize: size, weight: font)

        currentWeatherLabel.text = data.weather
        currentWeatherLabel.font = .systemFont(ofSize: size, weight: font)

        currentWeatherGIFImage.image = UIImage(systemName: data.weatherIcon)
        currentWeatherGIFImage.backgroundColor = .systemBlue

        currentTemperatureLabel.text = "\(data.temperature)°C"
        currentTemperatureLabel.font = .systemFont(ofSize: size + 5, weight: font)
    }
}

// MARK: - GIF ImagView

extension CurrentThumbnailCell {
    func setupGIFImageView() {
        contentView.addSubview(currentWeatherGIFImage)
        currentWeatherGIFImage.animate(withGIFNamed: "rain")
        currentWeatherGIFImage.startAnimatingGIF()
        currentWeatherGIFImage.contentMode = .scaleToFill
        currentWeatherGIFImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - TagView

extension CurrentThumbnailCell {
    func setupTagView() {
        currentWeatherGIFImage.addSubview(topTagView)
        topTagView.backgroundColor = UIColor(hexCode: "2ec4b6", alpha: 1)
        topTagView.layer.cornerRadius = 10
        topTagView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        topTagView.layer.masksToBounds = true
        topTagView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }

        contentView.addSubview(bottomTagView)
        bottomTagView.backgroundColor = UIColor(hexCode: "2ec4b6", alpha: 1)
        bottomTagView.snp.makeConstraints { make in
            make.centerX.leading.bottom.equalToSuperview()
            make.height.equalTo(80)
        }

        setupDateLabel()
    }

    func setupDateLabel() {
        topTagView.addSubview(dateLabel)
        dateLabel.text = "TODAY"
        dateLabel.textColor = .white
        dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - BottomTag Setting UI

extension CurrentThumbnailCell {
    func setupBottomTagViewUI() {
        setupWeatherIconImageView()
        setupRefreshButton()
        setupSuperStackView()
        setupCityNameLabel()
        setupTemperatureLabel()
    }

    func setupWeatherIconImageView() {
        bottomTagView.addSubview(currentWeatherIconImage)
        currentWeatherIconImage.contentMode = .center
        currentWeatherIconImage.image = UIImage(systemName: "cloud.rain")
        currentWeatherIconImage.layer.cornerRadius = 10
        currentWeatherIconImage.backgroundColor = UIColor(hexCode: "cbf3f0", alpha: 1)
        currentWeatherIconImage.tintColor = UIColor(hexCode: "2ec4b6", alpha: 1)
        currentWeatherIconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(15)
            make.width.equalTo(currentWeatherIconImage.snp.height)
        }
    }

    func setupRefreshButton() {
        bottomTagView.addSubview(refreshButton)
        refreshButton.setButtonImageView(imageName: "arrow.clockwise")
        refreshButton.setupButtonUI(cornerValue: 10, background: UIColor(hexCode: "ff9f1c"), fontColor: .white)
        refreshButton.tintColor = .white
        refreshButton.layer.masksToBounds = true
        refreshButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(refreshButton.snp.height)
        }
    }

    func setupSuperStackView() {
        bottomTagView.addSubview(superStackView)
        superStackView.configure(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 0)
        [currentCityNameLabel, currentTemperatureLabel].forEach {
            superStackView.addArrangedSubview($0)
        }

        superStackView.snp.makeConstraints { make in
            make.leading.equalTo(currentWeatherIconImage.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(15)
            make.trailing.equalTo(refreshButton.snp.leading).inset(-15)
        }
    }

    func setupCityNameLabel() {
        currentCityNameLabel.textAlignment = .center
        currentCityNameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        currentCityNameLabel.setupLabelColor(color: .white)
    }

    func setupTemperatureLabel() {
        currentTemperatureLabel.textAlignment = .center
        currentTemperatureLabel.font = .systemFont(ofSize: 22, weight: .bold)
        currentTemperatureLabel.setupLabelColor(color: .white)
    }
}

//
//  WeeklyTableViewCell.swift
//  Kaminari
//
//  Created by 이수현 on 2023/09/25.
//

import MultiSlider
import SnapKit
import UIKit

class WeeklyTableViewCell: UITableViewCell {
    let lowerTempList = WeatherManager.shared.weeklyForecastLowerTemp()
    let higherTempList = WeatherManager.shared.weeklyForcastHigherTemp()
    
    let dateLabel = WeeklyCustomLabel()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let lowerTempLabel = WeeklyCustomLabel()
    
    func gradientLayer(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
    
        return gradient
    }
    
    func gradientColor(gradientLayer: CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    let slider: MultiSlider = {
        let slider = MultiSlider()
        slider.orientation = .horizontal
        slider.outerTrackColor = .slider
        slider.trackWidth = 5
        slider.minimumValue = CGFloat(WeatherManager.shared.weeklyForecastLowerTemp()?.min() ?? 0)
        slider.maximumValue = CGFloat(WeatherManager.shared.weeklyForcastHigherTemp()?.max() ?? 1)
        
        slider.hasRoundTrackEnds = true
        slider.disabledThumbIndices = [0, 1]
        slider.thumbImage = UIImage()
        return slider
    }()
    
    func setSliderGradient() {
        let gradient = gradientLayer(bounds: bounds)
        slider.tintColor = gradientColor(gradientLayer: gradient)
    }
    
    let higherTempLabel = WeeklyCustomLabel()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setSliderGradient()
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeeklyTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WeeklyTableViewCell {
    func setupStackView() {
        dateLabel.setupLabelUI(fontColor: .reversedLabel)
        
        iconImageView.tintColor = .reversedLabel

        [dateLabel, iconImageView, lowerTempLabel, slider, higherTempLabel].forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
    }
}

extension WeeklyTableViewCell {
    func setDateLabel(_ index: Int, _ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"
        dateFormatter.locale = Locale(identifier: "ko")
        let convertStr = dateFormatter.string(from: date)
        if index == 0 {
            dateLabel.configure(text: "오늘", fontSize: 22, font: .bold)
        } else {
            dateLabel.configure(text: convertStr, fontSize: 18, font: .semibold)
        }
    }
    
    func setTemperature(_ index: Int) {
        lowerTempLabel.configure(text: "\(Int(lowerTempList?[index] ?? 0))º", fontSize: 18, font: .semibold)
        
        higherTempLabel.configure(text: "\(Int(higherTempList?[index] ?? 0))º", fontSize: 18, font: .semibold)
        
        if index == 0 {
            lowerTempLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            lowerTempLabel.setupLabelUI(fontColor: .systemBlue)
            
            higherTempLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            higherTempLabel.setupLabelUI(fontColor: .systemRed)
        } else {
            lowerTempLabel.setupLabelUI(fontColor: .reversedLabel)
            higherTempLabel.setupLabelUI(fontColor: .reversedLabel)
        }
    }
    
    func setIconImage(_ index: Int) {
        let symbolName = WeatherManager.shared.weather?.dailyForecast.forecast[index].symbolName
        iconImageView.image = UIImage(systemName: symbolName ?? "sun.max")
        iconImageView.contentMode = .scaleAspectFill
        if index == 0 {
            iconImageView.frame.size = CGSize(width: 100, height: 100)
            iconImageView.contentMode = .scaleAspectFill
        } else {
            iconImageView.frame.size = CGSize(width: 50, height: 50)
            iconImageView.contentMode = .scaleAspectFill
        }
    }
    
    func setSliderValue(_ index: Int) {
        slider.value = [CGFloat(lowerTempList?[index] ?? 0), CGFloat(higherTempList?[index] ?? 0)]
    }
    
    func setSliderLength(_ index: Int) {
        if index == 0 {
            iconImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(-65)
            }
            higherTempLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-12)
            }
            slider.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(100)
                make.right.equalTo(higherTempLabel.snp.left).offset(-12)
            }
            lowerTempLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(slider.snp.left).offset(-12)
            }
            
        } else {
            iconImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(-65)
            }
            higherTempLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-20)
            }
            slider.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(90)
                make.right.equalTo(higherTempLabel.snp.left).offset(-12)
            }
            lowerTempLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(slider.snp.left).offset(-12)
            }
        }
    }
}

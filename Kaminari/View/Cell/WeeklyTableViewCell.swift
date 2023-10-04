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

//    let slashLabel = WeeklyCustomLabel()
    
    let slider: MultiSlider = {
        let slider = MultiSlider()
        slider.orientation = .horizontal
        slider.outerTrackColor = .darkGray
        slider.trackWidth = 5
        slider.minimumValue = CGFloat(WeatherManager.shared.weeklyForecastLowerTemp()?.min() ?? 0)
        slider.maximumValue = CGFloat(WeatherManager.shared.weeklyForcastHigherTemp()?.max() ?? 1)
        slider.tintColor = .systemOrange
        slider.hasRoundTrackEnds = true
        slider.disabledThumbIndices = [0, 1]
        slider.thumbImage = UIImage()
        return slider
    }()
    
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
        dateLabel.setupLabelUI(fontColor: .label)
        
        iconImageView.tintColor = .label
        lowerTempLabel.setupLabelUI(fontColor: .label)
//        slashLabel.setupLabelUI(fontColor: .label)
        higherTempLabel.setupLabelUI(fontColor: .label)
        
//        [lowerTempLabel, slider, higherTempLabel].forEach { labelStackView.addArrangedSubview($0) }
        [dateLabel, iconImageView, lowerTempLabel, slider, higherTempLabel].forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-65)
        }
    }
    
    func setSliderLevel() {
        
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
        lowerTempLabel.configure(text: "\(Int(lowerTempList?[index] ?? 0))º", fontSize: 18, font: .regular)
        //        slashLabel.configure(text: "/", fontSize: 18, font: .regular)
        higherTempLabel.configure(text: "\(Int(higherTempList?[index] ?? 0))º", fontSize: 18, font: .regular)
        
        if index == 0 {
            lowerTempLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            //            slashLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            higherTempLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        }
    }
    
    func setIconImage(_ index: Int) {
        let symbolName = WeatherManager.shared.weather?.dailyForecast.forecast[index].symbolName
        iconImageView.image = UIImage(systemName: symbolName ?? "sun.max")
        if index == 0 {
            iconImageView.frame.size = CGSize(width: 100, height: 100)
            iconImageView.contentMode = .scaleAspectFill
        }
    }
    
    func setSliderValue(_ index: Int) {
        slider.value = [CGFloat(lowerTempList?[index] ?? 0), CGFloat(higherTempList?[index] ?? 0)]
    }
    

    
    func setSliderLength(_ index: Int) {
        if index == 0 {
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
            
            iconImageView.snp.makeConstraints { $0.width.equalTo(40) }
        } else {
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
            iconImageView.snp.makeConstraints { $0.width.equalTo(25) }
        }
    }
}

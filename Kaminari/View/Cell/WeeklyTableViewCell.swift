//
//  WeeklyTableViewCell.swift
//  Kaminari
//
//  Created by 이수현 on 2023/09/25.
//

import SnapKit
import UIKit

class WeeklyTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateLabel = WeeklyCustomLabel()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let lowerTempLabel = WeeklyCustomLabel()

    let slashLabel = WeeklyCustomLabel()
//    let progressBar: UIProgressView = {
//        let progressBar = UIProgressView()
//        progressBar.trackTintColor = .lightGray
//        progressBar.progressTintColor = .systemBlue
//        progressBar.progress = 0.1
//        return progressBar
//    }()
    
    let higherTempLabel = WeeklyCustomLabel()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
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
        slashLabel.setupLabelUI(fontColor: .label)
        higherTempLabel.setupLabelUI(fontColor: .label)
        
        [lowerTempLabel, slashLabel, higherTempLabel].forEach { labelStackView.addArrangedSubview($0) }
        [dateLabel, iconImageView, labelStackView].forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-50)
        }
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
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
            dateLabel.configure(text: "오늘", fontSize: 18, font: .semibold)
        } else {
            dateLabel.configure(text: convertStr, fontSize: 18, font: .semibold)
        }
    }

    func setTemperature(_ index: Int) {
        let lowerTemp = WeatherManager.shared.weather?.dailyForecast.forecast[index].lowTemperature
        let higherTemp = WeatherManager.shared.weather?.dailyForecast.forecast[index].highTemperature
        
        lowerTempLabel.configure(text: "\(Int(lowerTemp?.value ?? 0))º", fontSize: 18, font: .regular)
        slashLabel.configure(text: "/", fontSize: 18, font: .regular)
        higherTempLabel.configure(text: "\(Int(higherTemp?.value ?? 0))º", fontSize: 18, font: .regular)
    }
    
    func setIconImage(_ index: Int) {
        let symbolName = WeatherManager.shared.weather?.dailyForecast.forecast[index].symbolName
        iconImageView.image = UIImage(systemName: symbolName ?? "sun.max")
    }
}

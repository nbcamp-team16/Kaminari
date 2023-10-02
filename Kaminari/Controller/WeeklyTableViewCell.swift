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
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .lightGray
        progressBar.progress = 0.1
        return progressBar
    }()
    
    let higherTempLabel = WeeklyCustomLabel()
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 5
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
        dateLabel.setupLabelUI(fontColor: .white)
        
        iconImageView.tintColor = .white
        lowerTempLabel.setupLabelUI(fontColor: .white)
        higherTempLabel.setupLabelUI(fontColor: .white)
        
        [dateLabel, iconImageView, lowerTempLabel, progressBar, higherTempLabel].forEach { cellStackView.addArrangedSubview($0) }
        contentView.addSubview(cellStackView)
        
        cellStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
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
        higherTempLabel.configure(text: "\(Int(higherTemp?.value ?? 0))º", fontSize: 18, font: .regular)
    }
    
    func setIconImage(_ index: Int) {
        let symbolName = WeatherManager.shared.weather?.dailyForecast.forecast[index].symbolName
        iconImageView.image = UIImage(systemName: symbolName ?? "sun.max")
    }
    
    func setProgressBar(_ index: Int) {}
}

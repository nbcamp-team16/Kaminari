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
    
    let dateLabel = CustomLabel()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let lowerTempLabel = CustomLabel()
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        return progressBar
    }()
    
    let higherTempLabel = CustomLabel()
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
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
        dateLabel.configure(text: "월", fontSize: 18, font: .semibold)
        iconImageView.image = UIImage(systemName: "sun.max")
        lowerTempLabel.configure(text: "20º", fontSize: 18, font: .regular)
        higherTempLabel.configure(text: "30º", fontSize: 18, font: .regular)
        
        [dateLabel, iconImageView, lowerTempLabel, progressBar, higherTempLabel].forEach { cellStackView.addArrangedSubview($0) }
        contentView.addSubview(cellStackView)
        
        cellStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(62)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(36)
        }
    }
}

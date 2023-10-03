//
//  SearchTableViewCell.swift
//  Kaminari
//
//  Created by 보경 on 2023/09/28.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "searchVCCell"
    
    let wrapView = UIView()
    let temperature = UILabel()
    let city = UILabel()
    let weather = UILabel()
    let maxTemp = UILabel()
    let minTemp = UILabel()
    let weatherImg = UIImageView()
    let backgroundImg = UIImageView()
    
    func setupUI() {
        let screenWidth = UIScreen.main.bounds.width
        
        addSubview(wrapView)
        wrapView.snp.makeConstraints{ make in
            make.size.equalTo(CGSize(width: screenWidth - 30, height: 100))
            make.centerX.centerY.equalToSuperview()
        }
        
        wrapView.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints{ make in
            make.centerX.centerY.edges.equalToSuperview()
        }
        
        wrapView.addSubview(temperature)
        temperature.font = .systemFont(ofSize: 40, weight: .ultraLight)
        temperature.textColor = .white
        temperature.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(15)
        }
        
        wrapView.addSubview(city)
        city.font = .systemFont(ofSize: 15, weight: .bold)
        city.textColor = .white
        city.snp.makeConstraints{ make in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        wrapView.addSubview(weather)
        weather.font = .systemFont(ofSize: 15, weight: .thin)
        weather.textColor = .white
        weather.snp.makeConstraints{ make in
            make.top.equalTo(city.snp.top)
            make.left.equalTo(city.snp.right).offset(8)
        }
        
        wrapView.addSubview(weatherImg)
        weatherImg.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(15)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        wrapView.addSubview(minTemp)
        minTemp.font = .systemFont(ofSize: 15, weight: .thin)
        minTemp.textColor = .white
        minTemp.snp.makeConstraints{ make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(city.snp.top)
        }
        
        wrapView.addSubview(maxTemp)
        maxTemp.font = .systemFont(ofSize: 15, weight: .thin)
        maxTemp.textColor = .white
        maxTemp.snp.makeConstraints{ make in
            make.top.equalTo(city.snp.top)
            make.right.equalTo(minTemp.snp.left).offset(-8)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

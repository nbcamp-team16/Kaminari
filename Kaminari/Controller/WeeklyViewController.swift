//
//  WeeklyViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

class WeeklyViewController: UIViewController {
    var cityName: String = "현재 위치"
    var currentTemp: Int = 24
    var weatherSummury: String = "대체로 흐림"

    let cityNameLabel = CustomLabel()
    let detailLabel = CustomLabel()
    let tableTitle = CustomLabel()

    let line: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()

    let weeklyTable: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 15
        table.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.17)
        return table
    }()

    deinit {
        print("### ViewController deinitialized")
    }
}

extension WeeklyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 108.0/255.0, green: 202.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        configureUI()
        setupTable()
    }
}

private extension WeeklyViewController {
    func configureUI() {
        setupLabels()
        configureTable()
    }

    func setupLabels() {
        cityNameLabel.configure(text: cityName, fontSize: 40, font: .bold)
        detailLabel.configure(text: "\(currentTemp)º | \(weatherSummury)", fontSize: 20, font: .regular)
        tableTitle.configure(text: "주간 예보", fontSize: 18, font: .regular)

        cityNameLabel.setupLabelUI(fontColor: .white)
        detailLabel.setupLabelUI(fontColor: .white)
        tableTitle.setupLabelUI(fontColor: .white)

        [cityNameLabel, detailLabel, tableTitle].forEach {
            view.addSubview($0)
        }

        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        detailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityNameLabel.snp.bottom).offset(8)
        }

        tableTitle.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(23)
        }
    }

    func configureTable() {
        view.addSubview(line)
        view.addSubview(weeklyTable)

        line.snp.makeConstraints { make in
            make.top.equalTo(tableTitle.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(23)
            make.right.equalToSuperview().offset(-23)
            make.height.equalTo(1)
        }

        weeklyTable.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-23)
            make.top.equalTo(line.snp.bottom).offset(17)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-17)
        }
    }
}

extension WeeklyViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTable() {
        weeklyTable.dataSource = self
        weeklyTable.delegate = self
        weeklyTable.isScrollEnabled = false
        weeklyTable.register(WeeklyTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weeklyTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(DetailViewController(), animated: true)
    }
}

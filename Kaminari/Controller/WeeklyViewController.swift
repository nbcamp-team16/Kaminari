//
//  WeeklyViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

class WeeklyViewController: UIViewController {
    let date = Date()

    var cityName: String = "현재 위치"

    let sampleLatitude = 37.26
    let sampleLongitude = 127.03

    let cityNameLabel = WeeklyCustomLabel()
    let detailLabel = WeeklyCustomLabel()
    let tableTitle = WeeklyCustomLabel()

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
        configureUI()
        setupTable()
        setupBarButtonItem()
    }

    func viewWillAppear(_ animated: Bool) async {
        super.viewWillAppear(animated)
        await WeatherManager.shared.getWeather(latitude: sampleLatitude, longitude: sampleLongitude)
    }
}

extension WeeklyViewController {
    func setupBarButtonItem() {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(tappedResearchButton))
        barButtonItem.tintColor = .systemBackground
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func tappedResearchButton(_ sender: UIBarButtonItem) {
        weeklyTable.reloadData()
    }
}

private extension WeeklyViewController {
    func configureUI() {
        view.backgroundColor = UIColor(red: 108.0/255.0, green: 202.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        setupLabels()
        configureTable()
        print("----------\(WeatherManager.shared.weather?.currentWeather.temperature.value)")
    }

    func setupLabels() {
        let currentTemp = Int((WeatherManager.shared.weather?.currentWeather.temperature.value)!)
        let weatherSummury = WeatherManager.shared.weather?.currentWeather.condition.rawValue ?? "0"

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
            make.left.right.equalToSuperview().inset(23)
            make.height.equalTo(1)
        }

        weeklyTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(line.snp.bottom).offset(17)
            make.height.equalTo(440)
        }
    }
}

extension WeeklyViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTable() {
        weeklyTable.dataSource = self
        weeklyTable.delegate = self
        weeklyTable.isScrollEnabled = false
        weeklyTable.rowHeight = UITableView.automaticDimension
        weeklyTable.register(WeeklyTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weeklyTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeeklyTableViewCell

        let nextDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: date)
        cell.setDateLabel(indexPath.row, nextDate!)
        cell.setIconImage(indexPath.row)
        cell.setTemperature(indexPath.row)
        print(cell.bounds.height)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(DetailViewController(), animated: true)
    }
}

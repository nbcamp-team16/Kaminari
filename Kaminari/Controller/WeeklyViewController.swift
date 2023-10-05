//
//  WeeklyViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit
import WeatherKit
import Gifu

class WeeklyViewController: UIViewController {
    let serarchVC = SearchViewController()
    var gifImageView = GIFImageView(frame: .zero)
    let date = Date()

    var cityName: String = "현재 위치"
    let sampleLatitude = MapManager.shared.latitude
    let sampleLongitude = MapManager.shared.longitude

    let cityNameLabel = WeeklyCustomLabel()
    let detailLabel = WeeklyCustomLabel()
    let tableTitle = WeeklyCustomLabel()

    let line: UIView = {
        let line = UIView()
        line.backgroundColor = .label
        return line
    }()

    let weeklyTable: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 15
        table.backgroundColor = .table
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
        await WeatherManager.loadData(latitude: sampleLatitude ?? 0, longitude: sampleLongitude ?? 0) { [weak self] in
            guard let self = self else { return }
        }
    }
}

extension WeeklyViewController {
    func setupBarButtonItem() {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(tappedResearchButton))
        barButtonItem.tintColor = .label
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func tappedResearchButton(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(serarchVC, animated: true)
    }
}

private extension WeeklyViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.insertSubview(self.gifImageView, at: 0)
        self.gifImageView.stopAnimatingGIF()
        self.gifImageView.contentMode = .scaleAspectFit
        self.gifImageView.snp.makeConstraints({make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)})
        setupLabels()
        configureTable()
    }

    func setupLabels() {
        let weatherSummury = WeatherManager.shared.weather?.currentWeather.condition.rawValue ?? "0"

        cityNameLabel.configure(text: cityName, fontSize: 40, font: .bold)
        detailLabel.configure(text: "\(WeatherManager.shared.temp) | \(weatherSummury)", fontSize: 20, font: .regular)
        tableTitle.configure(text: "주간 예보", fontSize: 18, font: .regular)

        cityNameLabel.setupLabelUI(fontColor: .label)
        detailLabel.setupLabelUI(fontColor: .label)
        tableTitle.setupLabelUI(fontColor: .label)

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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
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
        cell.setSliderLength(indexPath.row)
        cell.setSliderValue(indexPath.row)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(DetailViewController(), animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return (weeklyTable.bounds.height - 60) / 9
        }
    }
}

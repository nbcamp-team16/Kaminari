//
//  CurrentViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import CoreLocation
import Gifu
import SnapKit
import UIKit
import WeatherKit

class CurrentViewController: UIViewController {
    var weather: Weather?
    var locationManager = MapManager.locationManager
    var latitude: Double?
    var longtitude: Double?
    
    var collectionView = CustomCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let refreshControl = UIRefreshControl()
    var gifImageView = GIFImageView(frame: .zero)
    
    var currentThumbnailWeatherList: [CurrentWeather] = CurrentWeather.weatherList
    var currentHourlyWeatherList: [CurrentHourlyWeather] = CurrentHourlyWeather.weatherList
    var currentDailyWeatherList: [CurrentDailyWeather] = CurrentDailyWeather.weatherList
        
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var tempArray: [Any]?
    
    let serarchVC = SearchViewController()
    
    deinit {
        print("### ViewController deinitialized")
    }
}

extension CurrentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        MapManager.shared.newLatitude = MapManager.shared.latitude
        MapManager.shared.newLongitude = MapManager.shared.longitude
        self.setupUI()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
}

extension CurrentViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        registerCollectionViewCell()
        registerCollectionViewHeader()
        self.configureCollectionView()
        self.collectionView.collectionViewLayout = self.createLayout()
        
        createDataSource()
        createSupplementaryView()
        applySnapshot()
        
        setupBarButtonItem()
        configureMapData()
        cofigunreGifView()
        
        setupRefreshControl()
    }
}

extension CurrentViewController {
    func setupBarButtonItem() {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.tappedResearchButton))
        barButtonItem.tintColor = .systemBackground
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func tappedResearchButton(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(self.serarchVC, animated: true)
    }
}

extension CurrentViewController {
    func cofigunreGifView() {
        view.insertSubview(self.gifImageView, at: 0)
        self.gifImageView.startAnimatingGIF()
        self.gifImageView.contentMode = .scaleToFill
        
        self.gifImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func configureCollectionView() {
        view.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    func registerCollectionViewCell() {
        self.collectionView.register(CurrentThumbnailCell.self, forCellWithReuseIdentifier: CurrentThumbnailCell.identifier)
        self.collectionView.register(CurrentTimelyCell.self, forCellWithReuseIdentifier: CurrentTimelyCell.identifier)
        self.collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
    }
    
    func registerCollectionViewHeader() {
        self.collectionView.register(CustomCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
                
            if sectionKind == .currentThumbnailWeatherList {
                let itemSize = self.collectionView.configureSectionItemSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = self.collectionView.configureSectionItem(layoutSize: itemSize)
                item.contentInsets = self.collectionView.configureContentInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = self.collectionView.configureSectionItemSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                    
                section.interGroupSpacing = 10
                section.contentInsets = self.collectionView.configureContentInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                    
            } else if sectionKind == .currentHourlyWeatherList {
                let itemSize = self.collectionView.configureSectionItemSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(0.5))
                let item = self.collectionView.configureSectionItem(layoutSize: itemSize)
                item.contentInsets = self.collectionView.configureContentInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                    
                let groupSize = self.collectionView.configureSectionItemSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = self.collectionView.configureContentInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
                
            } else if sectionKind == .currentDailyWeatherList {
                let itemSize = self.collectionView.configureSectionItemSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
                let item = self.collectionView.configureSectionItem(layoutSize: itemSize)
                item.contentInsets = self.collectionView.configureContentInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = self.collectionView.configureSectionItemSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                section = NSCollectionLayoutSection(group: group)

                section.contentInsets = self.collectionView.configureContentInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
                
            } else {
                fatalError("Unknown section!")
            }
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func createDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView) { collectionView, indexPath, _ -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            
            switch section {
            case .currentThumbnailWeatherList:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentThumbnailCell.identifier, for: indexPath) as? CurrentThumbnailCell else { preconditionFailure() }
                let item = CurrentWeather.weatherList[indexPath.row]
                cell.setupUI()
                cell.currentWeatherIconImage.image = UIImage(named: self.settingImageView(for: WeatherManager.shared.symbol))
                cell.currentTemperatureLabel.text = WeatherManager.shared.temp
                MapManager.shared.getCityName(latitude: MapManager.shared.newLatitude, longitude: MapManager.shared.newLongitude, completion: { locality in
                    DispatchQueue.main.async {
                        cell.currentCityNameLabel.text = locality
                    }
                })
                cell.layer.masksToBounds = true
                cell.layer.shadowOffset = CGSize(width: 2, height: 2)
                cell.layer.cornerRadius = 10
                cell.backgroundColor = .clear
                
                return cell
                
            case .currentHourlyWeatherList:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentTimelyCell.identifier, for: indexPath) as? CurrentTimelyCell else { preconditionFailure() }
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier, for: indexPath) as? CustomCollectionHeaderView else { return UICollectionViewCell() }
                header.setupTotalUI(title: "시간별 예보")
                cell.setupUI()
                cell.setupShadow(color: UIColor.black.cgColor, opacity: 0.5, radius: 3)
                cell.timeLabel.text = WeatherManager.shared.hourlyForecastTime(indexPath: indexPath.row).formatted(.dateTime.hour())
                cell.weatherIconImageView.image = UIImage(systemName: WeatherManager.shared.hourlyForecastSymbol(indexPath: indexPath.row))
                cell.temperatureLabel.text = WeatherManager.shared.hourlyForecastTemperature(indexPath: indexPath.row)
                cell.layer.shadowOffset = CGSize(width: 2, height: 2)
                cell.layer.cornerRadius = 10
                cell.backgroundColor = .systemBackground
                cell.layer.borderColor = UIColor.systemBackground.cgColor
                cell.layer.borderWidth = 0.5
                return cell
                
            case .currentDailyWeatherList:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as? CurrentWeatherCell else { preconditionFailure() }
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier, for: indexPath) as? CustomCollectionHeaderView else { return UICollectionViewCell() }
                header.setupTotalUI(title: "실시간 기상 정보")
                let item = self.tempArray?[indexPath.row]
                let titleItem = WeatherManager.shared.dailyTitleList[indexPath.row]
                cell.setupUI()
                cell.setupShadow(color: UIColor.black.cgColor, opacity: 0.5, radius: 3)
                cell.currentWeatherLabel.text = titleItem
                cell.currentTemperatureLabel.text = "\(item ?? "n/a")"
                cell.layer.shadowOffset = CGSize(width: 2, height: 2)
                cell.layer.cornerRadius = 10
                cell.backgroundColor = .systemBackground
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 0.5
                return cell
            }
        }
    }
    
    func createSupplementaryView() {
        self.dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier, for: indexPath) as? CustomCollectionHeaderView else { return nil }
            return header
        }
    }
        
    func applySnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)

        let currentThumbnailItem = self.currentThumbnailWeatherList.map { Item(currentThumbnailWeatherList: $0) }
        var currentThumbnailSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        currentThumbnailSnapshot.append(currentThumbnailItem)
                
        let currentTimelyItems = self.currentHourlyWeatherList.map { Item(currentHourlyWeatherList: $0) }
        var currentTimelySnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        currentTimelySnapshot.append(currentTimelyItems)
                
        let currentWeatherItems = self.currentDailyWeatherList.map { Item(currentDailyWeatherList: $0) }
        var currentWeatherSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        currentWeatherSnapshot.append(currentWeatherItems)
                
        self.dataSource.apply(currentThumbnailSnapshot, to: .currentThumbnailWeatherList, animatingDifferences: false)
        self.dataSource.apply(currentTimelySnapshot, to: .currentHourlyWeatherList, animatingDifferences: false)
        self.dataSource.apply(currentWeatherSnapshot, to: .currentDailyWeatherList, animatingDifferences: false)
    }
}

extension CurrentViewController {
    func fetchData() {
        Task {
            await WeatherManager.loadData(latitude: MapManager.shared.newLatitude, longitude: MapManager.shared.newLongitude) { [weak self] in
                guard let self = self else { return }
                self.tempArray = []
                let item = WeatherManager.shared.weather?.dailyForecast.forecast[0]
                self.tempArray?.append(item?.condition.rawValue ?? "n/a")
                self.tempArray?.append(addUnit(value: item?.highTemperature.value.rounded() ?? 0))
                self.tempArray?.append(addUnit(value: item?.lowTemperature.value.rounded() ?? 0))
                self.tempArray?.append(self.formattedDate(date: item?.sun.sunrise ?? Date()))
                self.tempArray?.append(self.formattedDate(date: item?.sun.sunset ?? Date()))
                self.tempArray?.append(item?.uvIndex.value.formatted() ?? "n/a")
                self.tempArray?.append(item?.wind.speed.value.formatted() ?? 0)
                DispatchQueue.main.async {
                    self.gifImageView.animate(withGIFNamed: self.settingGifImageView(for: WeatherManager.shared.symbol))
                    self.gifImageView.image?.withRenderingMode(.alwaysOriginal)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func configureMapData() {
        // 포그라운드일 때 위치 추적 권한 요청
        self.locationManager.requestWhenInUseAuthorization()

        // 배터리에 맞게 권장되는 최적의 정확도
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 사용자에게 허용 받기 alert 띄우기
        self.locationManager.requestWhenInUseAuthorization()

        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManager.startUpdatingLocation() // 위치 정보 받아오기 시작
                print("### \(self.locationManager.location?.coordinate)")
            } else {
                print("위치 서비스 Off 상태")
            }
        }

        // 위,경도 가져오기
        let coor = self.locationManager.location?.coordinate
        self.latitude = coor?.latitude
        self.longtitude = coor?.longitude
    }
}

extension CurrentViewController {
    func setupRefreshControl() {
        self.collectionView.refreshControl = self.refreshControl

        self.refreshControl.addTarget(self, action: #selector(self.refreshCollectionView), for: .valueChanged)

        self.refreshControl.tintColor = .systemBackground
        self.refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
    }

    @objc private func refreshCollectionView() {
        self.fetchData()
        WeatherManager.shared.weatherIndex += 1
        self.refreshControl.endRefreshing()
    }
}

extension CurrentViewController {
    func addUnit(value: Double) -> String {
        let result = Int(value)
        return "\(result)°C"
    }
    
    func formattedDate(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "a hh:mm"
    
        let resultTime = dateformatter.string(from: date)
        return resultTime
    }
    
    func settingGifImageView(for inputValue: String) -> String {
        var result = ""
        switch inputValue {
        case "sun.max":
            result = "sun"
        case "cloud":
            result = "cloud"
        case "cloud.moon.rain":
            result = "rain"
        case "cloud.moon":
            result = "moon"
        case "moon.stars":
            result = "moon"
        case "wind":
            result = "wind"
        default:
            result = "sun"
        }
        return result
    }
    
    func settingImageView(for inputValue: String) -> String {
        var result = ""
        switch inputValue {
        case "sun.max":
            result = "clear_sky_day"
        case "cloud":
            result = "clouds"
        case "cloud.moon.rain":
            result = "rain"
        case "cloud.moon":
            result = "moon"
        case "moon.stars":
            result = "clear_sky_night"
        case "wind":
            result = "wind"
        case "cloud.snow":
            result = "snow"
        case "cloud.bolt.rain":
            result = "thunderstorm_with_rain"
        case "tropicalstorm":
            result = "thunderstorm"
        case "tornado":
            result = "tornado"
        default:
            result = "atmosphere"
        }
        return result
    }
}

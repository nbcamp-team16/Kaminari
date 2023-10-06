//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit
import MapKit
import Foundation
import WeatherKit

let defaults = UserDefaults.standard // Userdefaults로 섭씨, 화씨 설정
let defaultUnit = ["tempUnit": "섭씨"] // 기본값



var locationData: [LocationData] = []

struct LocationData {
    var name: String?
    var latitude: Double?
    var longtitude: Double?
}

struct WeatherData {
    var condition: WeatherCondition?
    var symbolName: String?
    var date: Date?
    var temperature: Int?
    var isDaylight: Bool?
}

struct CurrentWeatherData {
    var locationData: LocationData
    var weatherData: WeatherData
}

class SearchViewController: UITableViewController {
    var weather: Weather?
    var tempWeatherData: WeatherData = WeatherData()
    var locationManager = MapManager.locationManager
    var currentWeatherData: [CurrentWeatherData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentLocant = configureMapData()
        print("현재 위치 데이터: \(currentLocant)")

        defaults.register(defaults: defaultUnit)
        
        view.backgroundColor = .systemBackground

        // register cell
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)

        // 테이블뷰 delegate
        tableView.delegate = self
        tableView.dataSource = self

        // cell 구분선 없애기
        tableView.separatorStyle = .none

       // 탭 바 없애기
        tabBarController?.tabBar.isHidden = true
        
        // dark mode
        view.window?.overrideUserInterfaceStyle = .dark
    }

    override func viewWillAppear(_ animated: Bool) {
        navBar()
        let currentLocant = configureMapData()
        
        if locationData.count == 0 {locationData.append(currentLocant)}
        else {locationData[0] = currentLocant}
             print("viewWillAppear locationData: \(String(describing: locationData))")
        
        fetchData(locationArray: locationData)
        view.window?.overrideUserInterfaceStyle = .dark
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.window?.overrideUserInterfaceStyle = .unspecified
    }

   func navBar() {
       let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
       menuButton.showsMenuAsPrimaryAction = true
       menuButton.menu = setMenu()
       menuButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)

       let barButton = UIBarButtonItem(customView: menuButton)
       barButton.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal, barMetrics: UIBarMetrics.default)

       self.navigationController?.navigationBar.prefersLargeTitles = true
       self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
       self.navigationController?.navigationBar.backgroundColor = .systemBackground
       self.navigationController?.navigationBar.shadowImage = UIImage()
       self.navigationItem.rightBarButtonItem = barButton
       
       let searchController = UISearchController(searchResultsController: SearchRegionViewController())
       searchController.searchResultsUpdater = searchController.searchResultsController as? SearchRegionViewController
       
       self.navigationItem.searchController = searchController
    
       self.navigationItem.searchController?.searchBar.placeholder = "도시 또는 공항 검색"
       self.navigationItem.searchController?.navigationItem.titleView = searchController.searchBar
       self.navigationItem.hidesSearchBarWhenScrolling = false
       self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
       
       self.navigationItem.title = "검색"
       self.navigationController?.navigationBar.tintColor = .label
    }

    @objc func setMenu() -> UIMenu {
        let celsius = UIAction(title: "섭씨", image: UIImage(systemName: "c.circle"), handler: {_ in
            print("섭씨")
            defaults.set("섭씨", forKey: "tempUnit")
            self.tableView.reloadData()
        })
        let fahrenheit = UIAction(title: "화씨", image: UIImage(systemName: "f.circle"), handler: {_ in
            print("화씨")
            defaults.set("화씨", forKey: "tempUnit")
            self.tableView.reloadData()
        })

        let menu = UIMenu(title: "", children: [celsius, fahrenheit])
        return menu
    }

    deinit {
        print("### SearchViewController deinitialized")
    }
    
    func configureMapData() -> LocationData{
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
                print(self.locationManager.location?.coordinate as Any)
            } else {
                print("위치 서비스 Off 상태")
            }
        }

        // 위,경도 가져오기
        var locant: LocationData = LocationData(name: "🧭 현재위치")
        let coor = self.locationManager.location?.coordinate
        locant.latitude = coor?.latitude
        locant.longtitude = coor?.longitude

        print("### 현재 위도 경도 : \(MapManager.shared.latitude) : \(MapManager.shared.longitude)")
        print("### 저장된 현재 locant 값 : 위도 - \(String(describing: locant.latitude)), 경도 - \(String(describing: locant.longtitude))")
        return locant
    }
    
    func fetchData(locationArray: [LocationData]) {
        let shared = WeatherManager.shared
        var tempcurrentWeatherData: [CurrentWeatherData] = []
        Task {
            for data in locationArray {
                let latitude = data.latitude ?? 0
                let longitude = data.longtitude ?? 0
                await shared.getWeather(latitude: latitude, longitude: longitude)
                let item = WeatherManager.shared.weather?.currentWeather
                
                if let condition = item?.condition {self.tempWeatherData.condition = condition}
                if let date = item?.date {self.tempWeatherData.date = date}
                if let symbolName = item?.symbolName {self.tempWeatherData.symbolName = symbolName}
                if let temperature = item?.temperature {
                    let temperatureInt = Int(temperature.converted(to: .celsius).value)
                    self.tempWeatherData.temperature = temperatureInt
                }
                if let isDaylight = item?.isDaylight {self.tempWeatherData.isDaylight = isDaylight}
                
                print("tempWeatherData : \(tempWeatherData)")
                let temp = CurrentWeatherData(locationData: data, weatherData: self.tempWeatherData)
                tempcurrentWeatherData.append(temp)
            }
            self.currentWeatherData = tempcurrentWeatherData
            self.tableView.reloadData() //
            print("### \(String(describing: self.currentWeatherData))")
        }
    }
}
            
extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {1}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentWeatherData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {120}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = defaults.string(forKey: "tempUnit")
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        let data = currentWeatherData?[indexPath.row]

        // cell 데이터 연결(임시로 dummy와 연결)
        switch unit {
        case "섭씨": cell.temperature.text = "\(String(describing: data!.weatherData.temperature!))℃"
        case "화씨": cell.temperature.text = "\(String(describing: Int(Double((data!.weatherData.temperature)!) * 1.8) + 32))℉"
        default : cell.temperature.text = "\(String(describing: data!.weatherData.temperature!))℃"
        }
                
        cell.weather.text = switchingWeatherInfoCase(data!.weatherData.condition ?? .clear, data!.weatherData.isDaylight ?? true)[0]
        cell.city.text = data?.locationData.name
        cell.weatherImg.image = UIImage(named: switchingWeatherInfoCase(data!.weatherData.condition ?? .clear, data!.weatherData.isDaylight ?? true)[1])
        cell.weatherImg.tintColor = .label
        
        switch data!.weatherData.isDaylight {
        case true: cell.backgroundImg.image = UIImage(named: "back_day_searchPage")
        case false: cell.backgroundImg.image = UIImage(named: "back_night_searchPage")
        default: cell.backgroundImg.image = UIImage(named: "back_day_searchPage")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLat = currentWeatherData![indexPath.row].locationData.latitude
        let selectedLong = currentWeatherData![indexPath.row].locationData.longtitude
        
        MapManager.shared.latitude = selectedLat!
        MapManager.shared.longitude = selectedLong!
        let currentVC = CurrentViewController()
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

func switchingWeatherInfoCase(_ condition: WeatherCondition, _ isDaylight: Bool) -> [String] {
    
    var conditionString: String
    var imgString: String
    switch condition {
    case .clear:
        conditionString = "맑음"
        if isDaylight {imgString = "clear_sky_day"}
        else {imgString = "clear_sky_night"}
    case .cloudy:
        conditionString = "흐림"
        imgString = "clouds"
    case .mostlyClear:
        conditionString = "대부분 맑음"
        if isDaylight {imgString = "clear_sky_day"}
        else {imgString = "clear_sky_night"}
    case .blowingDust:
        conditionString = "풍진"
        imgString = "atmosphere"
    case .foggy:
        conditionString = "안개"
        imgString = "atmosphere"
    case .haze:
        conditionString = "안개"
        imgString = "atmosphere"
    case .mostlyCloudy:
        conditionString = "대체로 흐림"
        imgString = "clouds"
    case .partlyCloudy:
        conditionString = "부분적으로 흐림"
        imgString = "clouds"
    case .smoky:
        conditionString = "침침한"
        imgString = "clouds"
    case .breezy:
        conditionString = "가벼운 바람"
        imgString = "wind"
    case .windy:
        conditionString = "강풍"
        imgString = "wind"
    case .drizzle:
        conditionString = "이슬비"
        imgString = "rain"
    case .heavyRain:
        conditionString = "폭우"
        imgString = "rain"
    case .isolatedThunderstorms:
        conditionString = "뇌우"
        imgString = "rain"
    case .rain:
        conditionString = "비"
        imgString = "rain"
    case .sunShowers:
        conditionString = "여우비"
        imgString = "rain"
    case .scatteredThunderstorms:
        conditionString = "뇌우"
        imgString = "thunderstorm_with_rain"
    case .strongStorms:
        conditionString = "강한 뇌우"
        imgString = "thunderstorm_with_rain"
    case .thunderstorms:
        conditionString = "뇌우"
        imgString = "thunderstorm_with_rain"
    case .frigid:
        conditionString = "서리"
        imgString = "snow"
    case .hail:
        conditionString = "빗발"
        imgString = "rain"
    case .hot:
        conditionString = "폭염"
        if isDaylight {imgString = "clear_sky_day"}
        else {imgString = "clear_sky_night"}
    case .flurries:
        conditionString = "폭풍우"
        imgString = "rain"
    case .sleet:
        conditionString = "진눈깨비"
        imgString = "snow"
    case .snow:
        conditionString = "눈"
        imgString = "snow"
    case .sunFlurries:
        conditionString = "눈보라"
        imgString = "snow"
    case .wintryMix:
        conditionString = "진눈깨비"
        imgString = "snow"
    case .blizzard:
        conditionString = "눈보라"
        imgString = "snow"
    case .blowingSnow:
        conditionString = "눈보라"
        imgString = "snow"
    case .freezingDrizzle:
        conditionString = "진눈깨비"
        imgString = "snow"
    case .freezingRain:
        conditionString = "어는 비"
        imgString = "snow"
    case .heavySnow:
        conditionString = "폭설"
        imgString = "snow"
    case .hurricane:
        conditionString = "허리케인"
        imgString = "tornado"
    case .tropicalStorm:
        conditionString = "열대성 폭풍"
        imgString = "tornado"
    default : conditionString = "맑음"
        if isDaylight {imgString = "clear_sky_day"}
        else {imgString = "clear_sky_night"}
    }
    return [conditionString, imgString]
}

//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit
import MapKit
import Foundation

let defaults = UserDefaults.standard // Userdefaults로 섭씨, 화씨 설정
let defaultUnit = ["tempUnit": "섭씨"] // 기본값

// dummy
let weather1 = WeatherInfo(temp: 25, cityName: "인천광역시", weather: .cloudyABit, maxTemp: 27, minTemp: 18)
let weather2 = WeatherInfo(temp: -4, cityName: "서울광역시", weather: .snowy, maxTemp: 3, minTemp: -8)
let weather3 = WeatherInfo(temp: 13, cityName: "광주광역시", weather: .rainy, maxTemp: 17, minTemp: 8)
let weather4 = WeatherInfo(temp: 33, cityName: "대구광역시", weather: .sunny, maxTemp: 34, minTemp: 27)
let weather5 = WeatherInfo(temp: 15, cityName: "제주특별시", weather: .thunder, maxTemp: 21, minTemp: 11)
let weather6 = WeatherInfo(temp: 15, cityName: "울산광역시", weather: .thunder, maxTemp: 21, minTemp: 11)

let data = [weather1, weather2, weather3, weather4, weather5, weather6]
let dummy = ["부평", "을지로", "왕십리", "을왕리", "울산"]

class SearchViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.register(defaults: defaultUnit)
        navBar()
        
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
        tableView.reloadData()
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
        })
        let fahrenheit = UIAction(title: "화씨", image: UIImage(systemName: "f.circle"), handler: {_ in           print("화씨")
        })

        let menu = UIMenu(title: "", children: [celsius, fahrenheit])
        return menu
    }

    deinit {
        print("### SearchViewController deinitialized")
    }
}
            
extension SearchViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {1}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {data.count}

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {120}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = defaults.string(forKey: "tempUnit")

        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell

        let weatherData = data[indexPath.row]

        // cell 데이터 연결(임시로 dummy와 연결)
        switch unit {
        case "섭씨":
            cell.temperature.text = String(weatherData.temp) + "℃"
            cell.maxTemp.text = "최고" + String(weatherData.maxTemp) + "℃"
            cell.minTemp.text = "최소" + String(weatherData.minTemp) + "℃"
            print(cell.temperature.text as Any)
        case "화씨":
            cell.temperature.text = String(Int(Double(weatherData.temp) * 1.8) + 32) + "℉"
            cell.maxTemp.text = "최고" + String(Int(Double(weatherData.maxTemp) * 1.8) + 32) + "℉"
            cell.minTemp.text = "최소" + String(Int(Double(weatherData.minTemp) * 1.8) + 32) + "℉"
            print(cell.temperature.text as Any)
        default :
            cell.temperature.text = String(weatherData.temp) + "℃"
            cell.maxTemp.text = "최고" + String(weatherData.maxTemp) + "℃"
            cell.minTemp.text = "최소" + String(weatherData.minTemp) + "℃"
            print(cell.temperature.text as Any)
        }

        let dataForEnumCase: WeatherInfoForWeatherCase = setWeatherUI(weatherCase: weatherData.weather, needString: true, needBackImg: true, needWeatherImg: true, weatherInfo: weatherData)

        cell.weather.text = dataForEnumCase.weatherString
        cell.weatherImg.image = UIImage(named: dataForEnumCase.weatherImgName!)
        cell.backgroundImg.image = UIImage(named: dataForEnumCase.BackImgName!)
        cell.city.text = weatherData.cityName

        return cell
    }
}

struct WeatherInfoForWeatherCase {
    var weatherString: String?
    var weatherImgName: String?
    var BackImgName: String?

    init(weatherString: String? = nil, weatherImgName: String? = nil, BackImgName: String? = nil) {
        self.weatherString = weatherString
        self.weatherImgName = weatherImgName
        self.BackImgName = BackImgName
    }
}

struct WeatherInfo {
    var temp: Int
    var cityName: String
    var weather: WeatherCase
    var maxTemp: Int
    var minTemp: Int
}

enum WeatherCase {
    case cloudyABit, snowy, rainy, sunny, thunder
}

func connectBoolWithString(weather: String, weatherImgName: String, backgroundImgName: String, _ needString: Bool, _ needBackImg: Bool, _ needWeatherImg: Bool) -> WeatherInfoForWeatherCase {
    var result = WeatherInfoForWeatherCase()
    if needString == true {result.weatherString = weather}
    if needBackImg == true {result.BackImgName = backgroundImgName}
    if needWeatherImg == true {result.weatherImgName = weatherImgName}
    return result
}


func setWeatherUI(weatherCase: WeatherCase, needString: Bool, needBackImg: Bool, needWeatherImg: Bool, weatherInfo: WeatherInfo) -> WeatherInfoForWeatherCase {
    switch weatherCase {
    case .cloudyABit:
        return connectBoolWithString(weather: "약간 흐림", weatherImgName: "cloudy_a_bit", backgroundImgName: "back_cloudy_a_bit", needString, needBackImg, needWeatherImg)
    case .snowy:
        return connectBoolWithString(weather: "눈", weatherImgName: "snowy", backgroundImgName: "back_snowy", needString, needBackImg, needWeatherImg)
    case .rainy:
        return connectBoolWithString(weather: "비", weatherImgName: "rainy", backgroundImgName: "back_rainy", needString, needBackImg, needWeatherImg)
    case .sunny:
        return connectBoolWithString(weather: "맑음", weatherImgName: "sunny", backgroundImgName: "back_sunny", needString, needBackImg, needWeatherImg)
    case .thunder:
        return connectBoolWithString(weather: "낙뢰", weatherImgName: "thunder", backgroundImgName: "back_thunder", needString, needBackImg, needWeatherImg)
    }
}


import UIKit
import MapKit
import SnapKit
import WeatherKit
import Then

var tempSave: LocationData?

class SearchRegionViewController: UITableViewController, UISearchResultsUpdating {
    
    var weather: Weather?
    var locationManager = MapManager.locationManager
    var selectedRegionCoordinate = CLLocationCoordinate2D()
    var searchCompleter = MKLocalSearchCompleter()
    var completionResults = [MKLocalSearchCompletion]()
    var cityName: String = ""
    var searchLog: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        
        tableView.register(SearchRegionTableViewCell.self, forCellReuseIdentifier: SearchRegionTableViewCell.identifier)
    }

    func updateSearchResults(for searchController: UISearchController) {
        // 사용자가 검색창에 텍스트를 입력할 때마다, searchCompleter의 queryFragment를 업데이트합니다.
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
    
    func fetchCoordinateForSuggestion(_ suggestion: MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let request = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            completion(response?.mapItems.first?.placemark.coordinate, error)
        }
    }
    
    func fetchNameForSuggestion(_ suggestion: MKLocalSearchCompletion, completion: @escaping (String?, Error?) -> Void) {
        let request = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            completion(response?.mapItems.first?.placemark.name, error)
        }
    }
}

extension SearchRegionViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // completer가 결과를 업데이트할 때마다 테이블 뷰를 리로드합니다.
        completionResults = completer.results
        tableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // 오류를 처리합니다.
        print(error.localizedDescription)
    }
}

extension SearchRegionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {2}
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "검색기록"
        case 1: return "도시명 검색"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return searchLog.count
        case 1: return completionResults.count
        default: return 1
        }
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchRegionTableViewCell.identifier, for: indexPath) as! SearchRegionTableViewCell
        switch indexPath.section {
            case 0:
            guard searchLog.count > 0 else {
                cell.regionLabel.text = "검색 기록이 없습니다."
                return cell
            }
                cell.regionLabel.text = searchLog[indexPath.row]
            return cell
            case 1:
            let suggestion = completionResults[indexPath.row]
            if completionResults == [] {cell.regionLabel.text = "정확한 도시, 지역명을 입력하세요."
                return cell
            }
            cell.regionLabel.text = suggestion.title
            return cell
        default: return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchRegionTableViewCell.identifier, for: indexPath) as! SearchRegionTableViewCell
        let selectedSuggestion = completionResults[indexPath.row]
        
        fetchCoordinateForSuggestion(selectedSuggestion) { [weak self](coordinate, error) in
            guard let coordinate = coordinate else {
                print("Error getting coordinate: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print("Coordinate: \(coordinate)")
            self?.selectedRegionCoordinate = coordinate
            let longitude = coordinate.longitude
            let latitude = coordinate.latitude
            tempSave = LocationData(latitude: latitude, longtitude: longitude)
            
            MapManager.shared.latitude = latitude
            MapManager.shared.longitude = longitude
            self?.toNextVC()
        }
        
        fetchNameForSuggestion(selectedSuggestion) { (administrativeArea, error) in
            guard let administrativeArea = administrativeArea else {
                print("Error getting locality: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.cityName = administrativeArea
            self.searchLog.append(administrativeArea)
            tempSave?.name = String(administrativeArea)
            print(tempSave)
            tableView.reloadData()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func toNextVC() {
        let nextVC = SearchResultViewController()
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.isNavigationBarHidden = false

        self.present(navigationController, animated: true)
    }
}

class SearchRegionTableViewCell: UITableViewCell {
    static let identifier = "searchRegionTC"

    let regionLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .init(white: 1.0, alpha: 0.1)
            print(regionLabel.text as Any)
        } else {
            self.backgroundColor = .none
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {
        addSubview(regionLabel)
        regionLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
    }

}

class SearchLogTableViewCell: UITableViewCell {
    static let identifier = "searchLogTC"

    let regionLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .init(white: 1.0, alpha: 0.1)
            print(regionLabel.text as Any)
        } else {
            self.backgroundColor = .none
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {
        addSubview(regionLabel)
        regionLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
    }

}

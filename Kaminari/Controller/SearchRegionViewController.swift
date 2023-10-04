import UIKit
import MapKit
import SnapKit
import WeatherKit
import Then

class SearchRegionViewController: UITableViewController, UISearchResultsUpdating {
    var weather: Weather?
    var locationManager = MapManager.locationManager
    var selectedRegionCoordinate = CLLocationCoordinate2D()
    var searchCompleter = MKLocalSearchCompleter()
    var completionResults = [MKLocalSearchCompletion]()

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

}

func fetchData(latitude: Double, longitude: Double) {
    Task {
        await WeatherManager.loadData(latitude: latitude, longitude: longitude) {
            let currentWeather = WeatherManager.shared.weather?.currentWeather
            print(currentWeather as Any)
            print(currentWeather?.symbolName)
            DispatchQueue.main.async {
            }
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completionResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchRegionTableViewCell.identifier, for: indexPath) as! SearchRegionTableViewCell
        let suggestion = completionResults[indexPath.row]
        cell.regionLabel.text = suggestion.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchRegionTableViewCell.identifier, for: indexPath) as! SearchRegionTableViewCell
        print(completionResults[indexPath.row].title)
        let selectedSuggestion = completionResults[indexPath.row]
        
        fetchCoordinateForSuggestion(selectedSuggestion) { (coordinate, error) in
            guard let coordinate = coordinate else {
                print("Error getting coordinate: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            print("Coordinate: \(coordinate)")
            self.selectedRegionCoordinate = coordinate
            print("selectedRegionCoordinate: \(self.selectedRegionCoordinate)")
            let longitude = coordinate.longitude
            let latitude = coordinate.latitude
            fetchData(latitude: latitude, longitude: longitude)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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

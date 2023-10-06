import CoreLocation
import MapKit
import SnapKit
import UIKit
import WeatherKit

class RegionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    // MARK: 프로퍼티 선언

    let customImage = UIImage(named: "Image")
    var weather: Weather?
    var locationManager = CLLocationManager()
    var mapView: MKMapView!

    deinit {
        print("### ViewController deinitialized")
    }

    // MARK: viewDidLoad 메서드

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        locationManager.delegate = self

        mapView = MKMapView()

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        Task {
            await fetchallcitysweather()

            DispatchQueue.main.async {
                self.addCustomPins()
                self.fetchData()
            }
        }

        mapView.setUserTrackingMode(.follow, animated: true)
        current()
    }

    // MARK: - MKMapViewDelegate 메서드

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseIdentifier = "customPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        guard let targetCity = WeatherManager.shared.getCity(latitude: annotation.coordinate.latitude,
                                                             longitude: annotation.coordinate.longitude)
        else {
            print("NO Result")
            return nil
        }

        if annotationView == nil {
            let currentWeather = WeatherManager.shared.weathers[targetCity]?.currentWeather
            let symbolName = currentWeather?.symbolName
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.image = UIImage(systemName: symbolName ?? "sun.max")

            let tempLabel = UILabel()
            if let temperature = currentWeather?.temperature {
                let tempInCelsius = Int(temperature.converted(to: .celsius).value)
                tempLabel.text = "\(tempInCelsius)°"
                tempLabel.textColor = .label
                tempLabel.backgroundColor = .systemBackground

            } else {
                tempLabel.text = "N/A"

                tempLabel.textColor = .label
                tempLabel.backgroundColor = .systemBackground
            }

            tempLabel.translatesAutoresizingMaskIntoConstraints = false

            annotationView?.addSubview(tempLabel)

            tempLabel.snp.makeConstraints { make in
                make.centerX.equalTo(annotationView!.snp.centerX)
                make.top.equalTo(annotationView!.snp.bottom)
            }
            annotationView?.frame.size = CGSize(width: 30, height: 30)
            annotationView?.canShowCallout = false

        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    // MARK: - 사용자 추적 모드 설정 메서드

    func setUserTrackingMode(mode: MKUserTrackingMode, animated: Bool) {}

    // MARK: - 커스텀 핀 추가 메서드

    func addCustomPins() {
        let pinCoordinates = City.allCases.map { $0.pinCoordinates }

        pinCoordinates.forEach { pin in
            let pinAnnotation = MKPointAnnotation()

            pinAnnotation.coordinate.latitude = pin.latitude
            pinAnnotation.coordinate.longitude = pin.longitude

            // 날씨 정보에 따라서 annotation title 변경
            if let closestCity = City.getCity(latitude: pin.latitude, longitude: pin.longitude),
               let cityWeatherData = WeatherManager.shared.weathers[closestCity]
            {}

            mapView.addAnnotation(pinAnnotation)
        }
    }

    // MARK: - 데이터 가져오기 메서드

    func fetchData() {
        City.allCases.forEach { city in
            Task {
                let pinCoordinates = city.pinCoordinates
                await WeatherManager.loadData(city: city) {
                    let manager = WeatherManager.shared.weathers
                    DispatchQueue.main.async {}
                }
            }
        }
    }

    // MARK: - 현재 지도 설정 메서드

    func current() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

    // MARK: - 모든 도시의 날씨 가져오기 메서드

    func fetchallcitysweather() async {
        for city in City.allCases {
            await WeatherManager.shared.getWeather(city: city)
        }
    }

    // MARK: - 사용자 위치를 중심으로 지도 이동 메서드

    @objc func centerMapOnUserLocation() {
        // 사용자의 현재 위치로 지도를 이동하는 함수
        if let userLocation = locationManager.location?.coordinate {
            let locationDegrees = 0.01
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: locationDegrees, longitudinalMeters: locationDegrees)
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - City 확장

extension City {
    // MARK: - 주어진 좌표에 가장 가까운 도시 찾기

    static func getCity(latitude: Double, longitude: Double) -> City? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var closestCity: City?
        var smallestDistance: CLLocationDistance?

        for city in City.allCases {
            let cityLocation = CLLocation(latitude: city.pinCoordinates.latitude,
                                          longitude: city.pinCoordinates.longitude)
            let distance = location.distance(from: cityLocation)

            if smallestDistance == nil || distance < smallestDistance! {
                smallestDistance = distance
                closestCity = city
            }
        }

        return closestCity
    }
}

import CoreLocation
import MapKit
import SnapKit
import UIKit
import WeatherKit

class RegionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let customImage = UIImage(named: "Image")
    // 이미지 추가
    var weather: Weather?
    var locationManager = CLLocationManager()
    var mapView: MKMapView!
    //    var count = 0

    deinit {
        print("### ViewController deinitialized")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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

    // fetchData 또는 mapView 순서 문제

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
//            print("###", currentWeather)
            let symbolName = currentWeather?.symbolName
//            print("###", symbolName)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.image = UIImage(systemName: symbolName ?? "sun.max")
            annotationView?.frame.size = CGSize(width: 30, height: 30)
            annotationView?.canShowCallout = false

        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

//    for city in City.allCases {
//        if let targetCity = WeatherManager.shared.getCity(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
//        {
//            if let currentWeather = WeatherManager.shared.weathers[targetCity]?.currentWeather {
//                print("City: \(targetCity), Current Weather: \(currentWeather)")
//            }
//        } else {
//            print("\(city)")
//        }
//    }
    // 네트워크 call 하기전에 map을 그리고 있다. 호출 부분 문제 또는 타이밍 문제

    func setUserTrackingMode(mode: MKUserTrackingMode, animated: Bool) {
        // Your code to set the user tracking mode goes here
    }

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

//        print(count)
//        for (index, coordinate) in pinCoordinates.enumerated() {
//            // 좌표, 제목 활용 반복문 사용한다.
//            let pinAnnotation = MKPointAnnotation()
//            // 객체를 생성한다.
//            pinAnnotation.coordinate = coordinate
//            // 객체의 좌표를 현재 좌표로 설정한다.
//            pinAnnotation.title = WeatherManager.shared.weather?.currentWeather.temperature.description
//            // 객체의 제목을 현재 좌표의 인덱스로 설정한다.
//            mapView.addAnnotation(pinAnnotation)
//            // 맵뷰에 객체를 추가하여 보이게 한다.
//        }

    func fetchData() {
        City.allCases.forEach { city in
            Task {
                let pinCoordinates = city.pinCoordinates
//                print("###", pinCoordinates)
                await WeatherManager.loadData(city: city) {
                    let manager = WeatherManager.shared.weathers
//                    print("###", manager)

//                    let currentWeather = WeatherManager.shared.weather?.currentWeather
//                    manager.weather?.currentWeather.date = currentWeather?.date ?? Date()
//                    manager.weather?.currentWeather.symbolName = currentWeather?.symbolName ?? "sun.max"
                    //                print(currentWeather as Any) // 필요하면 주석처리
                    //                print(currentWeather?.symbolName) // 필요하면 주석처리
                    //                print("###", manager.weather?.currentWeather.symbolName)
                    DispatchQueue.main.async {}
                }
            }
        }
    }

    func current() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

    func fetchallcitysweather() async {
//        do {
        for city in City.allCases {
            await WeatherManager.shared.getWeather(city: city)
        }

//        } catch {
//
//        }
    }

    @objc func centerMapOnUserLocation() {
        // 사용자의 현재 위치로 지도를 이동하는 함수
        if let userLocation = locationManager.location?.coordinate {
            let locationDegrees = 0.01
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: locationDegrees, longitudinalMeters: locationDegrees)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension City {
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

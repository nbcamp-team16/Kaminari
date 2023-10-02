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
    var count = 0
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)

        return button
    }()

    deinit {
        print("### ViewController deinitialized")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        refreshButton.addTarget(self, action: #selector(resetMap(_:)), for: .touchUpInside)
        locationManager.delegate = self

        mapView = MKMapView()

        mapView.delegate = self

        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addCustomPins() // 마커 추가하기
        print(count)

        view.addSubview(refreshButton)

        current()
        fetchData(latitude: 37.577535, longitude: 126.9779692)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { // MKannotaionView 설정
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

            // annotationView 가 없으면 새로 생성하거나 있으면 업데이트 한다.
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            //            annotationView?.canShowCallout = false
            annotationView?.image = UIImage(systemName: currentWeather?.symbolName ?? "sun.max")
            print("###", currentWeather?.symbolName)
            //            annotationView?.annotation?.title = currentWeather?.temperature ?? "°C"
            //            annotationView?.annotation?.title = currentWeather?.temperature ?? 0
            annotationView?.frame.size = CGSize(width: 20, height: 20)
            // 이미지의 사이즈를 조정한다.
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    private func addCustomPins() {
//        let pinCoordinates: [CLLocationCoordinate2D] = [
//            CLLocationCoordinate2D(latitude: 37.577535, longitude: 126.9779692),
//            // 서울
//            CLLocationCoordinate2D(latitude: 37.4562557, longitude: 126.7052062),
//            // 인천
//            CLLocationCoordinate2D(latitude: 36.3504119, longitude: 127.3845475),
//            // 대전
//            CLLocationCoordinate2D(latitude: 35.1795543, longitude: 129.0756416),
//            // 부산
//            CLLocationCoordinate2D(latitude: 35.8714354, longitude: 128.601445),
//            // 대구
//            CLLocationCoordinate2D(latitude: 35.1595454, longitude: 126.8526012),
//            // 광주
//            CLLocationCoordinate2D(latitude: 35.5383773, longitude: 129.31133596)
//            // 울산
//        ]

        let pinCoordinates = City.allCases.map { $0.pinCoordinates }

        pinCoordinates.forEach { pin in

//            let manager = WeatherManager.shared.weather?.currentWeather

            let pinAnnotation = MKPointAnnotation()

            pinAnnotation.coordinate.latitude = pin.latitude
            pinAnnotation.coordinate.longitude = pin.longitude

//            print("위도: \(index.latitude), 경도: \(index.longitude)")

            count += 1

//            pinAnnotation.title = manager?.temperature.description

            mapView.addAnnotation(pinAnnotation)
        }

        print(count)
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
    }

    func fetchData(latitude: Double, longitude: Double) {
        City.allCases.forEach { city in
            Task {
                let pinCoordinates = city.pinCoordinates
                await WeatherManager.loadData(city: city) {
                    let manager = WeatherManager.shared

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
        refreshButton.snp.makeConstraints { make in
            mapView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
                // 하단 10 tarbar를 보이게 하기 위해 띄워준다
            }
        }
    }

    @objc func resetMap(_ sender: UIButton) {
        let markerCoordinate = CLLocationCoordinate2D(latitude: 37.541, longitude: 126.986)

        let region = MKCoordinateRegion(center: markerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        mapView.setRegion(region, animated: true)
    }
}

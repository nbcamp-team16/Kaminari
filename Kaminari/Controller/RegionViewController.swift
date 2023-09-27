import CoreLocation
import MapKit
import SnapKit
import UIKit

class RegionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let customImage = UIImage(named: "Image")
    // 이미지 추가
    var locationManager = CLLocationManager()
    var mapView: MKMapView!

class RegionViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var mapView: MKMapView!
    // 초기화 버튼
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

        view.addSubview(refreshButton)

        current()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseIdentifier = "customPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            // annotationView 가 없으면 새로 생성하거나 있으면 업데이트 한다.
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
            annotationView?.image = customImage
            annotationView?.frame.size = CGSize(width: 20, height: 20)
            // 이미지의 사이즈를 조정한다.
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    private func addCustomPins() {
        let pinCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.577535, longitude: 126.9779692),
            // 서울
            CLLocationCoordinate2D(latitude: 37.4562557, longitude: 126.7052062),
            // 인천
            CLLocationCoordinate2D(latitude: 36.3504119, longitude: 127.3845475),
            // 대전
            CLLocationCoordinate2D(latitude: 35.1795543, longitude: 129.0756416),
            // 부산
            CLLocationCoordinate2D(latitude: 35.8714354, longitude: 128.601445),
            // 대구
            CLLocationCoordinate2D(latitude: 35.1595454, longitude: 126.8526012),
            // 광주
            CLLocationCoordinate2D(latitude: 35.5383773, longitude: 129.31133596)
            // 울산
        ]

        let pinTitles = ["서울", "인천", "대전", "부산", "대구", "광주", "울산"]

        for (index, coordinate) in pinCoordinates.enumerated() {
            // 좌표, 제목 활용 반복문 사용한다.
            let pinAnnotation = MKPointAnnotation()
            // 객체를 생성한다.
            pinAnnotation.coordinate = coordinate
            // 객체의 좌표를 현재 좌표로 설정한다.
            pinAnnotation.title = pinTitles[index]
            // 객체의 제목을 현재 좌표의 인덱스로 설정한다.
            mapView.addAnnotation(pinAnnotation)
            // 맵뷰에 객체를 추가하여 보이게 한다.
        }
    }

    func current() {
        refreshButton.snp.makeConstraints { make in
            mapView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
                // 하단 20 tarbar를 보이게 하기 위해 띄워준다
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.addTarget(self, action: #selector(resetMap(_:)), for: .touchUpInside)
        view.backgroundColor = UIColor(red: 108.0/255.0, green: 202.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        locationManager.delegate = self
        
        mapView = MKMapView()
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addCustomPin() // 마커 추가하기
        
        view.addSubview(refreshButton)
        
        current()
    }
    
    private func addCustomPin() {
        let pinCoordinate =
            CLLocationCoordinate2D(latitude: 37.541, longitude: 126.986)
        
        let pinAnnotation =
            MKPointAnnotation()
        
        pinAnnotation.coordinate =
            pinCoordinate
        
        pinAnnotation.title =
            "서울"
        
        pinAnnotation.subtitle =
            "선릉로"
        
        // 맵뷰에 마커 추가하기
        mapView.addAnnotation(pinAnnotation)
    }
    
    func current() {
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
        }
    }

    @objc func resetMap(_ sender: UIButton) {
        let markerCoordinate = CLLocationCoordinate2D(latitude: 37.541, longitude: 126.986)


        let region = MKCoordinateRegion(center: markerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)


        
        let region = MKCoordinateRegion(center: markerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
    }
}

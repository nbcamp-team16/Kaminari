import CoreLocation
import MapKit
import SnapKit
import UIKit

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
        
        mapView.setRegion(region, animated: true)
    }
}

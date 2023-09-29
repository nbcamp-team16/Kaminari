import CoreLocation
import MapKit
import SnapKit
import UIKit

class RegionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let customImage = UIImage(named: "Image")
    var locationManager = CLLocationManager()
    var mapView: MKMapView!
    
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
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
            annotationView?.image = customImage
            annotationView?.frame.size = CGSize(width: 20, height: 20)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    private func addCustomPins() {
        let pinCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.577535, longitude: 126.9779692),
            CLLocationCoordinate2D(latitude: 37.4562557, longitude: 126.7052062),
            CLLocationCoordinate2D(latitude: 36.3504119, longitude: 127.3845475),
            CLLocationCoordinate2D(latitude: 35.1795543, longitude: 129.0756416),
            CLLocationCoordinate2D(latitude: 35.8714354, longitude: 128.601445),
            CLLocationCoordinate2D(latitude: 35.1595454, longitude: 126.8526012),
            CLLocationCoordinate2D(latitude: 35.5383773, longitude: 129.31133596)
        ]

        let pinTitles = ["서울", "인천", "대전", "부산", "대구", "광주", "울산"]

        for (index, coordinate) in pinCoordinates.enumerated() {
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.coordinate = coordinate
            pinAnnotation.title = pinTitles[index]
            mapView.addAnnotation(pinAnnotation)
        }
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

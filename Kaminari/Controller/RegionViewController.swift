//
//  RegionViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import MapKit
import SnapKit
import UIKit

class RegionViewController: UIViewController {
    let testButton = CustomButton(frame: .zero)
    var mapView: MKMapView!
    // 최상위 라벨
    lazy var currentTimeLable: UILabel = {
        let label = UILabel()
        label.text = """
        현재 시간 9/25 14시 현재
        """
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        return label
    }()

    // 우측 상단 초기화 버튼
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)

        return button
    }()

    deinit {
        print("### ViewController deinitialized")
    }
}

extension RegionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 108.0/255.0, green: 202.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        // 맵뷰 생성
        mapView = MKMapView()
        // 초기 위치 설정
        let initialLocation = CLLocationCoordinate2D(latitude: 37.541, longitude: 126.986)
        // 보여줄 지역의 반경을 미터 단위로 설정
        let regionRadius: CLLocationDistance = 1000
        // 중심 좌표로 초기 위치를 설정하고, 경도 위도를 얼마나 보여줄지 반경을 정합니다.ㅁㅁㅁ
        let coordinateRegion = MKCoordinateRegion(center: initialLocation,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: true)
        refreshButton.addTarget(self, action: #selector(resetMap(_:)), for: .touchUpInside)

        view.addSubview(mapView)

        current()
    }

    func current() {
        view.addSubview(currentTimeLable)
        view.addSubview(refreshButton)

        currentTimeLable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
        }
        mapView.snp.makeConstraints { make in
            make.width.height.equalTo(400)
            make.center.equalToSuperview()
        }
    }

    // 맵이 리셋 되는 위치
    @objc func resetMap(_ sender: UIButton) {
        let initialLocation = CLLocationCoordinate2D(latitude: 37.541, longitude: 126.986)
        let regionRadius: CLLocationDistance = 1000

        let coordinateRegion = MKCoordinateRegion(center: initialLocation,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: true)
    }
}

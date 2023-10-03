//
//  MapManager.swift
//  TestWeatherKit
//
//  Created by (^ㅗ^)7 iMac on 2023/09/28.
//

import CoreLocation
import Foundation
import UIKit
import WeatherKit

class MapManager {
    static let shared = MapManager()

    static var locationManager = CLLocationManager()

    var latitude: Double {
//        locationManager.startUpdatingLocation()
        return MapManager.locationManager.location?.coordinate.latitude ?? 0.0
    }

    var longitude: Double {
//        locationManager.startUpdatingLocation()
        return MapManager.locationManager.location?.coordinate.longitude ?? 0.0
    }
}

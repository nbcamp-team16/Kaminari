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
    static var geocoder = CLGeocoder()

    var locale = Locale(identifier: "Ko-kr")

    var newLatitude: Double = 0
    var newLongitude: Double = 0

    var latitude: Double {
        get {
            return MapManager.locationManager.location?.coordinate.latitude ?? 0.0
        }
        set {
            self.newLatitude = newValue
        }
    }

    var longitude: Double {
        get {
            return MapManager.locationManager.location?.coordinate.longitude ?? 0.0
        }

        set {
            self.newLongitude = newValue
        }
    }

    func getCityName(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        MapManager.geocoder.reverseGeocodeLocation(.init(latitude: latitude, longitude: longitude), preferredLocale: self.locale) { [weak self] placemarks, _ in
            guard self != nil else { return }
            guard let placemarks = placemarks, let address = placemarks.last else { return }
            print("### \(placemarks)")
            guard let locality = address.locality else { return }
            completion(locality)
        }
    }
}

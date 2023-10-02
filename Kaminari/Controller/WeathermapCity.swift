//
//  WeathermapCity.swift
//  Kaminari
//
//  Created by t2023-m0053 on 2023/10/02.
//
import Foundation
import MapKit

enum City: CaseIterable {
    case seoul
    case incheon
    case busan

    var pinCoordinates: CLLocationCoordinate2D {
        switch self {
        case .seoul:
            return CLLocationCoordinate2D(latitude: 37.577535, longitude: 126.9779692)
        case .incheon:
            return CLLocationCoordinate2D(latitude: 37.4562557, longitude: 126.7052062)
        case .busan:
            return CLLocationCoordinate2D(latitude: 35.1795543, longitude: 129.0756416)
        }
    }
}

//
//  CurrentWeatherMockup.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import Foundation

struct CurrentWeatherMockup: Hashable {
    var location: String
    var temperature: Int
    var weather: String
    var weatherIcon: String
}

extension CurrentWeatherMockup {
    static let weatherList: [CurrentWeatherMockup] = [
        CurrentWeatherMockup(location: "대구광역시", temperature: 21, weather: "이슬비", weatherIcon: "cloudy")
    ]
}

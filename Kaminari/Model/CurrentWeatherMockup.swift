//
//  CurrentWeatherMockup.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import Foundation

struct CurrentWeather: Hashable {
    var id: UUID?
}

extension CurrentWeather {
    static let weatherList: [CurrentWeather] = [
        CurrentWeather(id: UUID()),
    ]
}

struct CurrentHourlyWeather: Hashable {
    var id: UUID?
}

extension CurrentHourlyWeather {
    static let weatherList: [CurrentHourlyWeather] = [
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
        CurrentHourlyWeather(id: UUID()),
    ]
}

struct CurrentDailyWeather: Hashable {
    var id: UUID?
}

extension CurrentDailyWeather {
    static let weatherList: [CurrentDailyWeather] = [
        CurrentDailyWeather(id: UUID()),
        CurrentDailyWeather(id: UUID()),
        CurrentDailyWeather(id: UUID()),
        CurrentDailyWeather(id: UUID()),
        CurrentDailyWeather(id: UUID()),
        CurrentDailyWeather(id: UUID()),
        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
//        CurrentDailyWeather(id: UUID()),
    ]
}

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
        CurrentWeatherMockup(location: "대구광역시", temperature: 23, weather: "흐림: ☁️", weatherIcon: "cloud"),
    ]
}

struct CurrentTimelyWeatherMockup: Hashable {
    var time: String
    var weatherIcon: String
    var temperature: String
}

extension CurrentTimelyWeatherMockup {
    static let weatherList: [CurrentTimelyWeatherMockup] = [
        CurrentTimelyWeatherMockup(time: "2시", weatherIcon: "cloud.rain", temperature: "21°C"),
        CurrentTimelyWeatherMockup(time: "3시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "4시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "5시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "6시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "7시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "8시", weatherIcon: "cloud.rain", temperature: "21°C"),
        CurrentTimelyWeatherMockup(time: "9시", weatherIcon: "cloud.rain", temperature: "21°C"),
        CurrentTimelyWeatherMockup(time: "10시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "11시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "12시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "13시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "14시", weatherIcon: "cloud.rain", temperature: "21°C"),

        CurrentTimelyWeatherMockup(time: "15시", weatherIcon: "cloud.rain", temperature: "21°C"),
    ]
}

struct CurrentWeathersMockup: Hashable {
    var title: String
    var temperature: String
    var description: String
}

extension CurrentWeathersMockup {
    static let weatherList: [CurrentWeathersMockup] = [
        CurrentWeathersMockup(title: "체감온도", temperature: "21°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "22°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "23°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "24°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "25°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "26°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "27°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
        CurrentWeathersMockup(title: "체감온도", temperature: "28°C", description: "강풍으로 인해 더욱 춥게 느껴질 수도 있습니다."),
    ]
}

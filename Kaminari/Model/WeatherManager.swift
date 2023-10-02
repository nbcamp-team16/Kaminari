//
//  WeatherManager.swift
//  TestWeatherKit
//
//  Created by (^ㅗ^)7 iMac on 2023/09/28.
//

import CoreLocation
import Foundation
import WeatherKit

class WeatherManager {
    static let shared = WeatherManager()

    var weather: Weather?

//    let dailyWeatherList: [Any] = [
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].condition,
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].highTemperature.value,
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].lowTemperature.value,
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].sun.sunrise,
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].sun.sunset,
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].uvIndex.value,
//        WeatherManager.shared.weather?.dailyForecast.forecast[1].wind.speed,
//    ]
//
    let dailyTitleList: [String] = ["기후", "최고 온도", "최저 온도", "일출", "일몰", "자외선 지수", "바람"]

    var symbol: String {
        weather?.currentWeather.symbolName ?? "sunmax"
    }

    var temp: String {
        let temp =
            weather?.currentWeather.temperature
        let convert = Int(temp?.converted(to: .celsius).value ?? 0)
        return "\(convert)°C"
    }

    func hourlyForecastTime(indexPath: Int) -> Date {
        let result = weather?.hourlyForecast.forecast[indexPath + 21].date ?? Date()
        return result
    }

    func hourlyForecastSymbol(indexPath: Int) -> String {
        let result = weather?.hourlyForecast.forecast[indexPath + 21].symbolName ?? "sun.max"
        return result
    }

    func hourlyForecastTemperature(indexPath: Int) -> String {
        guard let result = weather?.hourlyForecast.forecast[indexPath + 21].temperature.value else { return "0" }
        return "\(Int(result))°C"
    }

    func hourlyForecastTitle(indexPath: Int) -> String {
        let result = weather?.hourlyForecast.forecast[indexPath].condition
        return result?.rawValue ?? ""
    }

    func getWeather(latitude: Double, longitude: Double) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            }.value
        } catch {
            fatalError("\(error)")
        }
    }

    static func loadData(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        Task {
            await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude)
            completion()
        }
    }
}

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

    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }

    var temp: String {
        let temp =
            weather?.currentWeather.temperature

        let convert = Int(temp?.converted(to: .celsius).value ?? 0)
        return "\(convert)°C"
    }

    func getWeather(latitude: Double, longitude: Double) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude)) // Coordinates for Apple Park just as example coordinates

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

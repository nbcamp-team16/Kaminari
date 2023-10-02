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
    
    var weathers: [City: Weather] = [:]
  
    var weather: Weather?
  
    var symbol: String {
        weather?.currentWeather.symbolName ?? "sunmax"
    }
    
    var temp: String {
        let temp =
            weather?.currentWeather.temperature
    
        let convert = Int(temp?.converted(to: .celsius).value ?? 0)
        return "\(convert)°C"
    }
  
    func getCity(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> City? {
        return City.allCases.first { ($0.pinCoordinates.latitude == latitude) && ($0.pinCoordinates.longitude == longitude) }
    }

    func hourlyForecastTime(indexPath: Int) -> Date {
        let result = weather?.hourlyForecast.forecast[indexPath].date ?? Date()
        return result
    }
    
    func hourlyForecastSymbol(indexPath: Int) -> String {
        let result = weather?.hourlyForecast.forecast[indexPath].symbolName ?? "sun.max"
        return result
    }
    
    func hourlyForecastTemperature(indexPath: Int) -> String {
        guard let result = weather?.hourlyForecast.forecast[indexPath].temperature.value else { return "0" }
        return "\(Int(result))°C"
    }
    
    func hourlyForecastTitle(indexPath: Int) -> String {
        let result = weather?.hourlyForecast.forecast[indexPath].condition
        return result?.rawValue ?? ""
    }
    
    func getWeather(city: City) async {
        do {
            weathers[city] = try await Task.detached(priority: .userInitiated) {
                try await WeatherService.shared.weather(for: .init(latitude: city.pinCoordinates.latitude, longitude: city.pinCoordinates.longitude)) // Coordinates for Apple Park just as example coordinates
                
            }.value
        } catch {
            fatalError("\(error)")
        }
    }

    //
    static func loadData(city: City, completion: @escaping () -> Void) {
        Task {
            await WeatherManager.shared.getWeather(city: city)
            completion()
        }
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

extension WeatherManager {
    static let thumbnailList = WeatherManager.shared.weather?.currentWeather
    static let hourlyList = WeatherManager.shared.weather?.hourlyForecast
    static let dailyList = WeatherManager.shared.weather?.dailyForecast
}

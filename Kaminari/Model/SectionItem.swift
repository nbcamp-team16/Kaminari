//
//  SectionItem.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import Foundation

enum Section: Int, Hashable, CaseIterable {
    case currentThumbnailWeatherList, currentHourlyWeatherList, currentDailyWeatherList

    var description: String {
        switch self {
        case .currentThumbnailWeatherList: return "currentThumbnailWeatherList"
        case .currentHourlyWeatherList: return "currentHourlyWeatherList"
        case .currentDailyWeatherList: return "currentDailyWeatherList"
        }
    }
}

struct Item: Hashable {
    var currentThumbnailWeatherList: CurrentWeather?
    var currentHourlyWeatherList: CurrentHourlyWeather?
    var currentDailyWeatherList: CurrentDailyWeather?

    init(currentThumbnailWeatherList: CurrentWeather? = nil, currentHourlyWeatherList: CurrentHourlyWeather? = nil, currentDailyWeatherList: CurrentDailyWeather? = nil) {
        self.currentThumbnailWeatherList = currentThumbnailWeatherList
        self.currentHourlyWeatherList = currentHourlyWeatherList
        self.currentDailyWeatherList = currentDailyWeatherList
    }
}

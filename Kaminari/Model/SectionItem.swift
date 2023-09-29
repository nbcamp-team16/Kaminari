//
//  SectionItem.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import Foundation

enum Section: Int, Hashable, CaseIterable {
    case currentThumbnailWeatherList, currentTimelyWeatherList, currentWeatherList

    var description: String {
        switch self {
        case .currentThumbnailWeatherList: return "currentThumbnailWeatherList"
        case .currentTimelyWeatherList: return "currentTimelyWeatherList"
        case .currentWeatherList: return "currentWeatherList"
        }
    }
}

struct Item: Hashable {
    var currentThumbnailWeatherList: CurrentWeatherMockup?
    var currentTimelyWeatherList: CurrentTimelyWeatherMockup?
    var currentWeatherList: CurrentWeathersMockup?

    init(currentThumbnailWeatherList: CurrentWeatherMockup? = nil, currentTimelyWeatherList: CurrentTimelyWeatherMockup? = nil, currentWeatherList: CurrentWeathersMockup? = nil) {
        self.currentThumbnailWeatherList = currentThumbnailWeatherList
        self.currentTimelyWeatherList = currentTimelyWeatherList
        self.currentWeatherList = currentWeatherList
    }
}

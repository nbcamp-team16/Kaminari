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
    var currentTimelyWeatherList: CurrentWeatherMockup?
    var currentWeatherList: CurrentWeatherMockup?

    init(currentThumbnailWeatherList: CurrentWeatherMockup? = nil, currentTimelyWeatherList: CurrentWeatherMockup? = nil, currentWeatherList: CurrentWeatherMockup? = nil) {
        self.currentThumbnailWeatherList = currentThumbnailWeatherList
        self.currentTimelyWeatherList = currentTimelyWeatherList
        self.currentWeatherList = currentWeatherList
    }
}

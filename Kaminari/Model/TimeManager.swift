//
//  TimeManager.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/10/03.
//

import Foundation

class TimeManager {
    static let shared = TimeManager()
    
    private init() {}
    
    func getCurrentDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd"
        let result = formatter.string(from: Date())
        return Int(result) ?? 0
    }

    func getCurrentTime() -> Int {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "H"
        let result = formatter.string(from: Date())
        return Int(result) ?? 0
    }
}

//
//  UserDefaultsManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import Foundation

// MARK: - UserDefaultsKeys
struct UDKeys {
    static let period = "period"
    static let firstWeekDay = "firstWeekDay"
}

struct UDValues {
    static let periodType: PeriodType = .week
    static let firstWeekDay: Int = 2 // Monday
    static let userSinceYear: Int = 2022
}

// MARK: - UserDefaultsManager
class UDManager {
    
    static let shared = UDManager()
    
    let defaults = UserDefaults.standard
    
    
    // User default/selected period
    func savePeriod(_ period: Period) {
        defaults.setCodable(value: period, forKey: UDKeys.period)
    }
    
    func getPeriod() -> Period {
        return defaults.codableValue(forKey: UDKeys.period)
            ?? Period(type: UDValues.periodType, interval: Date().getDateInterval(in: UDValues.periodType))
    }
    
    
    // User default/selected first week day
    func saveFirstWeekDay(_ day: Int) {
        guard (1...7).contains(day) else { return }
        
        defaults.set(day, forKey: UDKeys.firstWeekDay)
    }
    
    func getFirstWeekDay() -> Int {
        return defaults.value(forKey: UDKeys.firstWeekDay) as? Int ?? UDValues.firstWeekDay
    }
}

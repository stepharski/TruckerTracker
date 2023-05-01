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
    static let distanceUnit = "distanceUnit"
    static let currency = "currency"
    static let weekStartDay = "weekStartDay"
    static let isDarkModeOn = "isDarkModeOn"
}

struct UDValues {
    static let userSinceYear: Int = 2022
    static let periodType: PeriodType = .week
    
    static let distanceUnit: DistanceUnit = .miles
    static let currency: Currency = .usd
    static let weekStartDay: Weekday = .monday
    static let isDarkModeOn: Bool = false
}

// MARK: - UserDefaultsManager
class UDManager {
    
    static let shared = UDManager()
    let defaults = UserDefaults.standard

    
    // Period
    var period: Period {
        get { return defaults.codableValue(forKey: UDKeys.period)
                    ?? Period(type: UDValues.periodType, interval: Date().getDateInterval(in: UDValues.periodType)) }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.period) }
    }
    
    // Distance unit
    var distanceUnit: DistanceUnit {
        get { return defaults.codableValue(forKey: UDKeys.distanceUnit) ?? UDValues.distanceUnit }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.distanceUnit) }
    }
    
    // Currency
    var currency: Currency {
        get { return defaults.codableValue(forKey: UDKeys.currency) ?? UDValues.currency }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.currency) }
    }
    
    // Week start day
    var weekStartDay: Weekday {
        get { return defaults.codableValue(forKey: UDKeys.weekStartDay) ?? UDValues.weekStartDay }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.weekStartDay) }
    }
    
    // Dark mode
    var isDarkModeOn: Bool {
        get { return (defaults.value(forKey: UDKeys.isDarkModeOn) as? Bool) ?? UDValues.isDarkModeOn }
        
        set { defaults.set(newValue, forKey: UDKeys.isDarkModeOn) }
    }
}

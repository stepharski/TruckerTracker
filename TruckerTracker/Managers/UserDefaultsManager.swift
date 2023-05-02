//
//  UserDefaultsManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import Foundation
import Combine

// MARK: - UserDefaults Keys
struct UDKeys {
    static let period = "period"
    static let homeDisplayPeriod = "homeDisplayPeriod"
    
    static let distanceUnit = "distanceUnit"
    static let currency = "currency"
    static let weekStartDay = "weekStartDay"
    static let isDarkModeOn = "isDarkModeOn"
}

// Default Values
struct UDValues {
    static let userSinceYear: Int = 2022
    static let periodType: PeriodType = .week
    
    static let distanceUnit: DistanceUnit = .miles
    static let currency: Currency = .usd
    static let weekStartDay: Weekday = .monday
    static let isDarkModeOn: Bool = false
}

// MARK: - UserDefaults Manager
class UDManager {
    
    static let shared = UDManager()
    let defaults = UserDefaults.standard

    
    // Home Display Period
    var homeDisplayPeriod: Period {
        get { return defaults.codableValue(forKey: UDKeys.homeDisplayPeriod) ?? Period.getDefault() }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.homeDisplayPeriod) }
    }
    
    // OLD Period
    var period: Period {
        get { return defaults.codableValue(forKey: UDKeys.period) ?? Period.getDefault() }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.period) }
    }
    
    // Distance unit
    var distanceUnit: DistanceUnit {
        get { return defaults.codableValue(forKey: UDKeys.distanceUnit) ?? UDValues.distanceUnit }
        
        set {
            defaults.setCodable(value: newValue, forKey: UDKeys.distanceUnit)
            NotificationCenter.default.post(name: .distanceUnitChanged, object: nil)
        }
    }
    
    // Currency
    var currency: Currency {
        get { return defaults.codableValue(forKey: UDKeys.currency) ?? UDValues.currency }
        
        set {
            defaults.setCodable(value: newValue, forKey: UDKeys.currency)
            NotificationCenter.default.post(name: .currencyChanged, object: nil)
        }
    }
    
    // Week start day
    var weekStartDay: Weekday {
        get { return defaults.codableValue(forKey: UDKeys.weekStartDay) ?? UDValues.weekStartDay }
        
        set {
            defaults.setCodable(value: newValue, forKey: UDKeys.weekStartDay)
            NotificationCenter.default.post(name: .weekStartDayChanged, object: nil)
        }
    }
    
    // Dark mode
    var isDarkModeOn: Bool {
        get { return (defaults.value(forKey: UDKeys.isDarkModeOn) as? Bool) ?? UDValues.isDarkModeOn }
        
        set { defaults.set(newValue, forKey: UDKeys.isDarkModeOn) }
    }
}

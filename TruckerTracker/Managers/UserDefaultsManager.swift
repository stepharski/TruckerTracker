//
//  UserDefaultsManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import UIKit

// MARK: - UserDefaults Keys
struct UDKeys {
    static let dashboardPeriod = "dashboardPeriod"
    static let distanceUnit = "distanceUnit"
    static let currency = "currency"
    static let weekStartDay = "weekStartDay"
    static let appTheme = "appTheme"
}

// Default Values
struct UDValues {
    static let userSinceYear: Int = 2022
    static let periodType: PeriodType = .week
    
    static let distanceUnit: DistanceUnit = .miles
    static let currency: Currency = .usd
    static let weekStartDay: Weekday = .monday
    static let appTheme: AppTheme = .system
}

// MARK: - UserDefaults Manager
class UDManager {
    
    static let shared = UDManager()
    let defaults = UserDefaults.standard

    
    // Dashboard Period
    var dashboardPeriod: Period {
        get { return defaults.codableValue(forKey: UDKeys.dashboardPeriod) ?? Period.getDefault() }
        
        set { defaults.setCodable(value: newValue, forKey: UDKeys.dashboardPeriod) }
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
    
    // App theme
    var appTheme: AppTheme {
        get { return defaults.codableValue(forKey: UDKeys.appTheme) ?? UDValues.appTheme }
        
        set {
            defaults.setCodable(value: newValue, forKey: UDKeys.appTheme)
            updateUserInterface(with: newValue.style)
        }
    }
    
    func updateUserInterface(with style: UIUserInterfaceStyle) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = style
    }
    
    // Reset
    func resetAll() {
        dashboardPeriod = Period.getDefault()
        distanceUnit = UDValues.distanceUnit
        currency = UDValues.currency
        weekStartDay = UDValues.weekStartDay
        appTheme = UDValues.appTheme
    }
}

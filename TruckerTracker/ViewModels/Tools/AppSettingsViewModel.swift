//
//  AppSettingsViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

// MARK: - AppSettings Type
enum AppSettingsType {
    case distance
    case currency
    case weekStartDay
    case theme
}

// MARK: - AppSettingsOption ViewModel
protocol AppSettingsOptionViewModel {
    var type: AppSettingsType { get }

    var image: UIImage? { get }
    var title: String { get }
    var stringValue: String? { get }

    var valueIndex: Int? { get }
    var allTypes: [String]? { get }
}


// MARK: - ToolsSettingsViewModel
class AppSettingsViewModel {

    var settings: [AppSettingsOptionViewModel]

    // Init
    init() {
        settings = [ DistanceSettingVM(),       // Distance
                    CurrencySettingVM(),       // Currency
                    WeekStartDaySettingVM(),    // Week start day
                    ThemeSettingVM() ]         // Theme
    }

    // Update
    func updateSettings(_ setting: AppSettingsOptionViewModel, valueIndex: Int) {
        switch setting.type {
        case .distance:
            if let distanceVM = setting as? DistanceSettingVM,
               let distanceUnit = DistanceUnit.allCases[safe: valueIndex] {
                distanceVM.distanceUnit = distanceUnit
            }
            
        case .currency:
            if let currencyVM = setting as? CurrencySettingVM,
               let currency = Currency.allCases[safe: valueIndex] {
                currencyVM.currency = currency
            }
            
        case .weekStartDay:
            if let weekStartDayVM = setting as? WeekStartDaySettingVM,
               let weekStartDay = Weekday.allCases[safe: valueIndex] {
                weekStartDayVM.weekStartDay = weekStartDay
            }
            
        case .theme:
            if let themeVM = setting as? ThemeSettingVM,
               let appTheme = AppTheme.allCases[safe: valueIndex] {
                themeVM.theme = appTheme
            }
        }
    }

    // Reset
    func resetAllSettings() {
        UDManager.shared.resetAll()
    }
}


// MARK: - AppSettingsOption ViewModels
// Distance
private class DistanceSettingVM: AppSettingsOptionViewModel {
    var type: AppSettingsType = .distance
    var image: UIImage? = SFSymbols.steeringWheel
    var title: String = "Distance"
    
    var distanceUnit: DistanceUnit {
        get { return UDManager.shared.distanceUnit }
        set { UDManager.shared.distanceUnit = newValue }
    }

    var stringValue: String? {
        return distanceUnit.title
    }

    var valueIndex: Int? {
        return DistanceUnit.allCases.firstIndex(of: distanceUnit)
    }

    var allTypes: [String]? {
        return DistanceUnit.allCases.map { $0.title }
    }
}

// Currency
private class CurrencySettingVM: AppSettingsOptionViewModel {
    var type: AppSettingsType = .currency
    var image: UIImage? = SFSymbols.banknote
    var title: String = "Currency"

    var currency: Currency {
        get { return UDManager.shared.currency }
        set { UDManager.shared.currency = newValue }
    }

    var stringValue: String? {
        return currency.title
    }

    var valueIndex: Int? {
        return Currency.allCases.firstIndex(of: currency)
    }

    var allTypes: [String]? {
        return Currency.allCases.map { $0.title }
    }
}

// Week start day
private class WeekStartDaySettingVM: AppSettingsOptionViewModel {
    var type: AppSettingsType = .weekStartDay
    var image: UIImage? = SFSymbols.calendar
    var title: String = "Week start day"

    var weekStartDay: Weekday {
        get { return UDManager.shared.weekStartDay }
        set { UDManager.shared.weekStartDay = newValue }
    }

    var stringValue: String? {
        return weekStartDay.title
    }

    var valueIndex: Int? {
        return Weekday.allCases.firstIndex(of: weekStartDay)
    }

    var allTypes: [String]? {
        return Weekday.allCases.map { $0.title }
    }
}

// Theme
private class ThemeSettingVM: AppSettingsOptionViewModel {
    var type: AppSettingsType = .theme
    var image: UIImage? =  SFSymbols.moon
    var title: String = "Theme"

    var theme: AppTheme {
        get { return UDManager.shared.appTheme }
        set { UDManager.shared.appTheme = newValue }
    }

    var stringValue: String? {
        return theme.title
    }

    var valueIndex: Int? {
        return AppTheme.allCases.firstIndex(of: theme)
    }

    var allTypes: [String]? {
        return AppTheme.allCases.map { $0.title }
    }
}

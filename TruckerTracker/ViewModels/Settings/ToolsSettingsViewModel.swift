//
//  ToolsSettingsViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/25/23.
//

import UIKit

// MARK: - ToolsViewModelOption
protocol ToolsViewModelOption {
    var type: ToolsSettingsType { get }
    
    var image: UIImage? { get }
    var title: String { get }
    var stringValue: String? { get }
    
    var valueIndex: Int? { get }
    var allTypes: [String]? { get }
}

// MARK: - ToolsSettingsViewModel
class ToolsSettingsViewModel {
    
    var options: [ToolsViewModelOption]
    
    // Init
    init() {
        options = [ ToolsViewModelDistanceOption(),     // Distance
                ToolsViewModelCurrencyOption(),       // Currency
                ToolsViewModelWeekStartDayOption(),  // Week start day
                ToolsViewModelThemeOption() ]      // Theme
    }
    
    // Update
    func updateOption(_ option: ToolsViewModelOption, valueIndex: Int) {
        switch option.type {
        case .distance:
            if let distanceOption = option as? ToolsViewModelDistanceOption,
               let distanceUnit = DistanceUnit.allCases[safe: valueIndex] {
                distanceOption.distanceUnit = distanceUnit
            }
            
        case .currency:
            if let currencyOption = option as? ToolsViewModelCurrencyOption,
               let currency = Currency.allCases[safe: valueIndex] {
                currencyOption.currency = currency
            }
            
        case .weekStartDay:
            if let weekStartDayOption = option as? ToolsViewModelWeekStartDayOption,
               let weekStartDay = Weekday.allCases[safe: valueIndex] {
                weekStartDayOption.weekStartDay = weekStartDay
            }
            
        case .theme:
            if let themeOption = option as? ToolsViewModelThemeOption,
               let appTheme = AppTheme.allCases[safe: valueIndex] {
                themeOption.theme = appTheme
            }
        }
    }
    
    func resetAllSettings() {
        UDManager.shared.resetAll()
    }
}

// MARK: - ToolsViewModel Options definition
// Distance
class ToolsViewModelDistanceOption: ToolsViewModelOption {
    var type: ToolsSettingsType = .distance
    
    var image: UIImage? { return type.image }
    var title: String { return type.title }
    var stringValue: String? { return distanceUnit.title }
    
    var distanceUnit: DistanceUnit {
        get { return UDManager.shared.distanceUnit }
        set { UDManager.shared.distanceUnit = newValue }
    }
    
    var valueIndex: Int? {
        return DistanceUnit.allCases.firstIndex(of: distanceUnit)
    }
    
    var allTypes: [String]? {
        return DistanceUnit.allCases.map { $0.title }
    }
}

// Currency
class ToolsViewModelCurrencyOption: ToolsViewModelOption {
    var type: ToolsSettingsType = .currency
    
    var image: UIImage? { return type.image }
    var title: String { return type.title }
    var stringValue: String? { return currency.title }
    
    var currency: Currency {
        get { return UDManager.shared.currency }
        set { UDManager.shared.currency = newValue }
    }
    
    var valueIndex: Int? {
        return Currency.allCases.firstIndex(of: currency)
    }
    
    var allTypes: [String]? {
        return Currency.allCases.map { $0.title }
    }
}

// Week start day
class ToolsViewModelWeekStartDayOption: ToolsViewModelOption {
    var type: ToolsSettingsType = .weekStartDay
    
    var image: UIImage? { return type.image }
    var title: String { return type.title }
    var stringValue: String? { return weekStartDay.title }
    
    var weekStartDay: Weekday {
        get { return UDManager.shared.weekStartDay }
        set { UDManager.shared.weekStartDay = newValue }
    }
    
    var valueIndex: Int? {
        return Weekday.allCases.firstIndex(of: weekStartDay)
    }
    
    var allTypes: [String]? {
        return Weekday.allCases.map { $0.title }
    }
}

// Theme
class ToolsViewModelThemeOption: ToolsViewModelOption {
    var type: ToolsSettingsType = .theme
    
    var image: UIImage? { return type.image }
    var title: String { return type.title }
    var stringValue: String? { return theme.title }
    
    var theme: AppTheme {
        get { return UDManager.shared.appTheme }
        set { UDManager.shared.appTheme = newValue }
    }
    
    var valueIndex: Int? {
        return AppTheme.allCases.firstIndex(of: theme)
    }
    
    var allTypes: [String]? {
        return AppTheme.allCases.map { $0.title }
    }
}

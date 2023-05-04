//
//  AppSettingsEnums.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/3/23.
//

import UIKit

// MARK: - DistanceUnits
enum DistanceUnit: String, Codable, CaseIterable {
    case miles, kilometers
    
    var title: String {
        return rawValue.capitalized
    }
    
    var abbreviation: String {
        switch self {
        case .miles:
            return "mi"
        case .kilometers:
            return "km"
        }
    }
}

// MARK: - Currency
enum Currency: String, Codable, CaseIterable {
    case usd, euro
    
    var title: String {
        switch self {
        case .usd:
            return rawValue.uppercased()
        default:
            return rawValue.capitalized
        }
    }
    
    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .euro:
            return "€"
        }
    }
}

// MARK: - Weekday
enum Weekday: String, Codable, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var title: String {
        return rawValue.capitalized
    }
    
    var number: Int {
        return Weekday.allCases.firstIndex(of: self)! + 1
    }
}

// MARK: - AppTheme
enum AppTheme: String, Codable, CaseIterable {
    case system
    case light
    case dark
    
    var title: String {
        return rawValue.capitalized
    }
    
    var style: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

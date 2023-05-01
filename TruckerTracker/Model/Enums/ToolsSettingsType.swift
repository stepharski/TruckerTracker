//
//  ToolsSettingsType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/25/23.
//

import UIKit

// MARK: - ToolsSettingsType
enum ToolsSettingsType: String, CaseIterable {
    case distance
    case currency
    case weekStartDay
    case darkMode
    
    var title: String {
        switch self {
        case .distance, .currency:
            return self.rawValue.capitalized
        case .weekStartDay:
            return "Week starts on"
        case .darkMode:
            return "Dark mode"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .distance:
            return SFSymbols.steeringWheel
        case .currency:
            return SFSymbols.banknote
        case .weekStartDay:
            return SFSymbols.calendar
        case .darkMode:
            return SFSymbols.moon
        }
    }
}

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

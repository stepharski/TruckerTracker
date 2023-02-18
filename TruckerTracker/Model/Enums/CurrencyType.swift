//
//  CurrencyType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

enum CurrencyType: String, Codable {
    case usd, euro
    
    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .euro:
            return "€"
        }
    }
}

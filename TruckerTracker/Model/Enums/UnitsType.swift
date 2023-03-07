//
//  UnitsType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

enum DistanceType: String, Codable {
    case miles, kilometers
    
    var abbreviation: String {
        switch self {
        case .miles:
            return "mi"
        case .kilometers:
            return "km"
        }
    }
}

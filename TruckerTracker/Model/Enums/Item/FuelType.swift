//
//  FuelType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

enum FuelType: String {
    case diesel, def, both
    
    var title: String {
        switch self {
        case .diesel, .def:
            return self.rawValue.capitalized
        case .both:
            return "Diesel & Def"
        }
    }
    
    var symbol: UIImage? {
        switch self {
        case .diesel, .both:
            return SFSymbols.fuelPumpFill
        case .def:
            return SFSymbols.dropFill
        }
    }
}

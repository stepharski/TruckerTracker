//
//  FuelType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import Foundation

enum FuelType: String {
    case diesel, def, gas
    
    var title: String {
        return self.rawValue.capitalized
    }
}

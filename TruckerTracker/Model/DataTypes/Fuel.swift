//
//  Fuel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

struct Fuel {
    
    let id: String
    let date: Date
    let amount: Int
    let type: FuelType
    
    var dieselAmount: Int?
    var dieselGallons: Int?
    var dieselPrice: Double?
    
    var defAmount: Int?
    var defGallons: Int?
    var defPrice: Double?
    
    var location: String?
    var documents: [String]?
}

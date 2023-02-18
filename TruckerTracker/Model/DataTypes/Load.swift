//
//  Load.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

struct Load {
    
    let id: String
    let date: Date
    let amount: Int
    
    let distance: Int
    var emptyDistance: Int?
    
    let startLocation: String
    let endLocation: String
    
    var middleLocations: [String]?
    var documents: [String]?
}

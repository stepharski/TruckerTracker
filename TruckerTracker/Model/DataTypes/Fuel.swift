//
//  Fuel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

class Fuel {
    
    let id: String
    var date: Date
    
    var dieselAmount: Double
    var defAmount: Double?
    var reeferAmount: Double?
    
    var totalAmount: Double {
        return dieselAmount + (defAmount ?? 0) + (reeferAmount ?? 0)
    }
    
    var location: String?
    var attachments: [String]?
    
    
    init(id: String, date: Date, dieselAmount: Double,
         defAmount: Double? = nil, reeferAmount: Double? = nil,
         location: String? = nil, attachments: [String]? = nil) {
        self.id = id
        self.date = date
        
        self.dieselAmount = dieselAmount
        self.defAmount = defAmount
        self.reeferAmount = reeferAmount
        
        self.location = location
        self.attachments = attachments
    }
    
    static func template() -> Fuel {
        return Fuel(id: UUID().uuidString, date: Date(), dieselAmount: 0)
    }
}

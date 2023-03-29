//
//  Fuel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

class Fuel {
    
    let id: String
    let date: Date
    let totalAmount: Double
    
    var dieselAmount: Double
    var defAmount: Double?
    var reeferAmount: Double?
    
    var location: String?
    var attachments: [String]?
    
    
    init(id: String, date: Date, dieselAmount: Double,
         defAmount: Double? = nil, reeferAmount: Double? = nil,
         location: String? = nil, attachments: [String]? = nil) {
        self.id = id
        self.date = date
        self.totalAmount = dieselAmount + (defAmount ?? 0) + (reeferAmount ?? 0)
        
        self.dieselAmount = dieselAmount
        self.defAmount = defAmount
        self.reeferAmount = reeferAmount
        
        self.location = location
        self.attachments = attachments
    }
    
    static func getEmpty() -> Fuel {
        let id: String = UUID().uuidString
        let date: Date = Date()
        let dieselAmount: Double = 50
        
        return Fuel(id: id, date: date, dieselAmount: dieselAmount)
    }
}

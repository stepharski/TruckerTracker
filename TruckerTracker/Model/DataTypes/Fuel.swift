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
    let amount: Double
    
    var dieselAmount: Int?
    var dieselGallons: Int?
    var dieselPrice: Double?
    
    var defAmount: Int?
    var defGallons: Int?
    var defPrice: Double?
    
    var location: String?
    var documents: [String]?
    
    
    init(id: String, date: Date, amount: Double,
         dieselAmount: Int? = nil, dieselGallons: Int? = nil, dieselPrice: Double? = nil,
         defAmount: Int? = nil, defGallons: Int? = nil, defPrice: Double? = nil,
         location: String? = nil, documents: [String]? = nil) {
        self.id = id
        self.date = date
        self.amount = amount
        self.dieselAmount = dieselAmount
        self.dieselGallons = dieselGallons
        self.dieselPrice = dieselPrice
        self.defAmount = defAmount
        self.defGallons = defGallons
        self.defPrice = defPrice
        self.location = location
        self.documents = documents
    }
    
    static func getDefault() -> Fuel {
        let id: String = UUID().uuidString
        let date: Date = Date()
        let amount: Double = 0
        
        return Fuel(id: id, date: date, amount: amount)
    }
}

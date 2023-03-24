//
//  Load.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

class Load {
    
    let id: String
    let date: Date
    let amount: Double
    let distance: Int
    var emptyDistance: Int?
    let startLocation: String
    let endLocation: String
    var documents: [String]?
    
    
    init(id: String, date: Date, amount: Double, distance: Int,
         emptyDistance: Int? = nil, startLocation: String,
         endLocation: String, documents: [String]? = nil) {
        self.id = id
        self.date = date
        self.amount = amount
        self.distance = distance
        self.emptyDistance = emptyDistance
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.documents = documents
    }
    
    static func getDefault() -> Load {
        let id: String = UUID().uuidString
        let date: Date = Date()
        let amount: Double = 0
        let distance: Int = 0
        let startLocation: String = ""
        let endLocation: String = ""
        
        // Test purpose
        let documents = ["LoadConfiramtion1"]
        
        return Load(id: id, date: date, amount: amount, distance: distance,
                    startLocation: startLocation, endLocation: endLocation, documents: documents)
    }
}

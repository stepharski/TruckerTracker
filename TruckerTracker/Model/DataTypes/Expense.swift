//
//  Expense.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

class Expense {
    
    let id: String
    let date: Date
    let amount: Double
    let name: String
    let frequency: FrequencyType
    
    var note: String?
    var documents: [String]?
    
    
    init(id: String, date: Date, amount: Double, name: String, frequency: FrequencyType, note: String? = nil, documents: [String]? = nil) {
        self.id = id
        self.date = date
        self.amount = amount
        self.name = name
        self.frequency = frequency
        self.note = note
        self.documents = documents
    }
}

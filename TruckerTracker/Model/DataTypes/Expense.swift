//
//  Expense.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

struct Expense {
    
    let id: String
    let date: Date
    let amount: Int
    let name: String
    let frequency: FrequencyType
    
    var note: String?
    var documents: [String]?
}

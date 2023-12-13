//
//  ValidationError.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/26/23.
//

import Foundation

enum ValidationError: String, Error {
    
    case itemNullAmount = "Can't proceed with zero amount.\nIt must be greater than 0."
    
    case expenseNoName = "Expenses need names too.\nPlease give your spending a title."
    
    case loadNullDistance = "Ready to hit the road?\nTrip distance is the missing piece!"
    case loadNoStartLocation = "Where's the starting point?\nPlease enter a valid pickup location."
    case loadNoEndLocation = "Destination missing!\nPlease enter a valid delivery location."
}

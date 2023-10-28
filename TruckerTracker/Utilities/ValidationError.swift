//
//  ValidationError.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/26/23.
//

import Foundation

enum ValidationError: String, Error {
    
    case nullAmount = "Can't roll with zero cash!\nAmount must be greater than 0."
    case nullDistance = "Ready to hit the road?\nTrip distance is the missing piece!"
    case emptyStartLocation = "Where's the starting point?\nPlease enter a valid pickup location."
    case emptyEndLocation = "Destination missing!\nPlease enter a valid delivery location."
}

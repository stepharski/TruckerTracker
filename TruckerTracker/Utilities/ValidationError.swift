//
//  ValidationError.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/26/23.
//

import Foundation

enum ValidationError: String, Error {
    
    case nullAmount = "Can't roll with zero cash!\nAmount must be greater than 0."
}

//
//  OperationError.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/19/23.
//

import Foundation

enum OperationError: String, Error {
    
    case persistentStoresError = "Couldn't load persistent store"
    case dataProcessingError = "Something went wrong while processing your request. Please try again."
}

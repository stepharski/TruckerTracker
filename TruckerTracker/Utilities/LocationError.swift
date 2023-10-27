//
//  LocationError.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/26/23.
//

import Foundation

enum LocationError: String, Error {
    
    case timeoutError = "The request for your location timed out."
    case networkError = "Please check your internet connection and try again."
    case defaultLocationError = "An error occurred while retrieving location."
    case permissionLocationError = "Please grant location permissions in Settings to use this feature."
}

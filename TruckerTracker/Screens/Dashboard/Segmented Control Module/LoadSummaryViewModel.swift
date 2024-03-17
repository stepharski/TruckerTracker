//
//  LoadSummaryViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/2/23.
//

import Foundation

struct LoadSummaryViewModel {
    
    let date: String
    let amount: String
    let distance: String
    let startLocation: String
    let endLocation: String
    
    init(_ model: Load) {
        date = model.date.convertToMonthDayFormat()
        
        let currencySymbol = UDManager.shared.currency.symbol
        amount = "\(currencySymbol)\(model.grossAmount.formattedWithSeparator())"
        
        let distanceSymbol = UDManager.shared.distanceUnit.abbreviation
        distance = "\(model.distance.formattedWithSeparator()) \(distanceSymbol)"
        
        startLocation = model.startLocation
        endLocation = model.endLocation
    }
}

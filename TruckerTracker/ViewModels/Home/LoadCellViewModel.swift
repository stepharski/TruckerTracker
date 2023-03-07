//
//  LoadCellViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import Foundation

struct LoadCellViewModel {
    
    let date: String
    let amount: String
    let distance: String
    let startLocation: String
    let endLocation: String
    
    init(_ model: Load) {
        date = model.date.convertToMonthDayFormat()
        
        let currencySymbol = UDManager.shared.getCurrencyType().symbol
        amount = "\(currencySymbol)\(model.amount.formattedWithSeparator())"
        
        let distanceSymbol = UDManager.shared.getDistanceType().symbol
        distance = "\(model.distance.formattedWithSeparator()) \(distanceSymbol)"
        
        startLocation = model.startLocation
        endLocation = model.endLocation
    }
}

//
//  FuelCellViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import UIKit

struct FuelCellViewModel {
    
    let date: String
    let title: String
    let amount: String
    let location: String
    let fuelImage: UIImage?
    
    init(_ model: Fuel) {
        title = model.type.title
        date = model.date.convertToMonthDayFormat()
        
        let currencySymbol = UDManager.shared.getCurrencyType().symbol
        amount = "\(currencySymbol)\(model.amount.formattedWithSeparator())"
        
        location = model.location ?? "Nowhereville, NA"
        fuelImage = model.type.symbol
    }
}
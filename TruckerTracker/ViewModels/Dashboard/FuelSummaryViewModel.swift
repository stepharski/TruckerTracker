//
//  FuelSummaryViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/2/23.
//

import UIKit

struct FuelSummaryViewModel {
    
    let date: String
    var title: String
    let amount: String
    let location: String
    let fuelImage: UIImage?
    
    init(_ model: Fuel) {
        title = "Diesel"
        if model.defAmount != nil && model.reeferAmount == nil {
            title.append(" & Def")
        } else if model.defAmount != nil && model.reeferAmount != nil {
            title.append(",Def & Reefer")
        }
        
        date = model.date.convertToMonthDayFormat()
        
        let currencySymbol = UDManager.shared.currency.symbol
        amount = "\(currencySymbol)\(model.totalAmount.formattedWithSeparator())"
        
        location = model.location ?? "Nowhereville, NA"
        fuelImage = SFSymbols.fuelPumpFill
    }
}

//
//  FuelSummaryViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/2/23.
//

import UIKit

struct FuelSummaryViewModel {
    
    let date: String
    let title: String
    let amount: String
    let location: String
    let fuelImage: UIImage?
    
    init(_ model: Fuel) {
        date = model.date.convertToMonthDayFormat()
        fuelImage = SFSymbols.fuelPumpFill
        location = model.location
        
        let fuelTypes: [(String, Double)] = [("Diesel", model.dieselAmount),
                                             ("Def", model.defAmount),
                                             ("Reefer", model.reeferAmount)]
        let nonZeroTitles = fuelTypes.filter { $0.1 != 0 }.map { $0.0 }
        title = nonZeroTitles.isEmpty ? "No Fuel" : nonZeroTitles.joined(separator: ", ")
        
        let currencySymbol = UDManager.shared.currency.symbol
        amount = "\(currencySymbol)\(model.totalAmount.formattedWithSeparator())"
    }
}

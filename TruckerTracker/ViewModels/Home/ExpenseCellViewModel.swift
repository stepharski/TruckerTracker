//
//  ExpenseCellViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import UIKit

struct ExpenseCellViewModel {
    
    let name: String
    let date: String
    let amount: String
    let frequencyTitle: String
    let frequencyImage: UIImage?
    
    init(_ model: Expense) {
        name = model.name
        date = model.date.convertToMonthDayFormat()
        
        let currencySymbol = UDManager.shared.currency.symbol
        amount = "\(currencySymbol)\(model.amount.formattedWithSeparator())"
        
        frequencyTitle = model.frequency.title
        frequencyImage = model.frequency.image
    }
}

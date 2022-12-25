//
//  Date+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/24/22.
//

import Foundation

extension Date {
    
    func convertToMonthDayFormat() -> String {
        return formatted(.dateTime.month().day())
    }
}

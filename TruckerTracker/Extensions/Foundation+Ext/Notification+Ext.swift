//
//  Notification+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/1/23.
//

import Foundation

extension Notification.Name {
    
    static let distanceUnitChanged = Notification.Name("DistanceUnitChanged")
    static let currencyChanged = Notification.Name("CurrencyChanged")
    static let weekStartDayChanged = Notification.Name("WeekStartDayChanged")
    static let itemEntryCompleted = Notification.Name("itemEntryCompleted")
    
}

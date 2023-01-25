//
//  Calendar+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/24/23.
//

import Foundation

extension Calendar {
    
    static func getCurrent() -> Calendar {
        var currentCalendar = current
        currentCalendar.firstWeekday = UDManager.shared.getFirstWeekDay()
        currentCalendar.minimumDaysInFirstWeek = Constants.minimumDaysInFirstWeek
        
        return currentCalendar
    }
}

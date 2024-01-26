//
//  Calendar+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/24/23.
//

import Foundation

extension Calendar {
    
    static func userCurrent() -> Calendar {
        var currentCalendar = current
        currentCalendar.firstWeekday = UDManager.shared.weekStartDay.number
        currentCalendar.minimumDaysInFirstWeek = Constants.minimumDaysInFirstWeek
        
        return currentCalendar
    }
    
    static func userCurrentUTC() -> Calendar {
        var currentCalendar = userCurrent()
        if let utc = TimeZone(secondsFromGMT: 0) { currentCalendar.timeZone = utc }
        
        return currentCalendar
    }
    
    func isLeapYear(_ year: Int) -> Bool {
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0)
                                          || (year % 400 == 0))
        
        return isLeapYear
    }
    
    
}

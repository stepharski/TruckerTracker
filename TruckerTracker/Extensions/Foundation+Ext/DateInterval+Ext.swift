//
//  DateInterval+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/25/23.
//

import Foundation

extension DateInterval {
    
    var middleDate: Date {
        let middleStamp = start.timeIntervalSince1970 + duration / 2
        return Date(timeIntervalSince1970: middleStamp)
    }
    
    private var roundedToNextDay: DateInterval {
        return DateInterval(start: start, end: end.nextDayAtMidnight)
    }
    
    
    // Week or CustomPeriod
    func nextInterval() -> DateInterval {
        let roundedIntvl = self.roundedToNextDay
        let newDuration  = roundedIntvl.duration
        let newStart = roundedIntvl.start.advanced(by: newDuration)
        
        return DateInterval(start: newStart, duration: newDuration - 1)
    }
    
    func previousInterval() -> DateInterval {
        let roundedIntvl = self.roundedToNextDay
        let newDuration  = roundedIntvl.duration
        let newStart = roundedIntvl.start.advanced(by: -newDuration)
        
        return DateInterval(start: newStart, duration: newDuration - 1)
    }
    

    // Month
    func nextMonthInterval() -> DateInterval {
        let calendar = Calendar.userCurrentUTC()
        let nextStart = end.nextDayAtMidnight
        if let nextEnd = calendar.date(byAdding: .month, value: 1, to: nextStart) {
            return DateInterval(start: nextStart, end: nextEnd - 1)
        }
        return self
    }
    
    func previousMonthInterval() -> DateInterval {
        let calendar = Calendar.userCurrentUTC()
        if let previousStart = calendar.date(byAdding: .month, value: -1, to: start) {
            return DateInterval(start: previousStart, end: start - 1)
        }
        
        return self
    }
    
    
    // Year
    func nextYearInterval() -> DateInterval {
        let calendar = Calendar.userCurrentUTC()
        let nextStart = end.nextDayAtMidnight
        if let nextEnd = calendar.date(byAdding: .year, value: 1, to: nextStart) {
            return DateInterval(start: nextStart, end: nextEnd - 1)
        }
        return self
    }
    
    func previousYearInterval() -> DateInterval {
        let calendar = Calendar.userCurrentUTC()
        if let previousStart = calendar.date(byAdding: .year, value: -1, to: start) {
            return DateInterval(start: previousStart, end: start - 1)
        }
        
        return self
    }
}

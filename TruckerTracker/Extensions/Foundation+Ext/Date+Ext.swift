//
//  Date+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/24/22.
//

import Foundation

extension Date {
    
    // Day time
    var startOfDay: Date {
        return Calendar.userCurrentUTC().startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let calendar = Calendar.userCurrentUTC()
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components) ?? self
    }
    
    // Next Day
    var nextDayAtMidnight: Date {
        var calendar = Calendar.userCurrent()
        if let utc = TimeZone(secondsFromGMT: 0) { calendar.timeZone = utc }
        let components = DateComponents(hour:0, minute:0, second: 0)
        
        return calendar.nextDate(after: self, matching: components,
                                      matchingPolicy: .nextTime) ?? self
    }
    
    // Local
    var local: Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second,
                                              value: Int(timeZoneOffset),
                                              to: self)
        return localDate ?? self
    }
    
    // Components
    var yearNumber: Int {
        let calendar = Calendar.userCurrent()
        return calendar.component(.year, from: self)
    }
    
    var weekdayName: String {
        let calendar = Calendar.userCurrent()
        let weekdayIndex = calendar.component(.weekday, from: self)
        let weekdaySymbols = calendar.weekdaySymbols
        
        return weekdaySymbols[weekdayIndex - 1]
    }
    
    var dayNumberInYear: Int {
        let calendar = Calendar.userCurrent()
        return calendar.ordinality(of: .day, in: .year, for: self) ?? 0
    }

    
    // Convert
    func convertToYearFormat() -> String {
        let formatter = createUTCFormatter(withFormat: "yyyy")
        return formatter.string(from: self)
    }
    
    func converToMonthYearFormat() -> String {
        let formatter = createUTCFormatter(withFormat: "MMMM yyyy")
        return formatter.string(from: self)
    }
    
    func convertToMonthDayFormat() -> String {
        let formatter = createUTCFormatter(withFormat: "MMMM dd")
        return formatter.string(from: self)
    }
    
    func convertToMonthDayYearFormat() -> String {
        let formatter = createUTCFormatter(withFormat: "MMM dd, yy")
        return formatter.string(from: self)
    }
    
    private func createUTCFormatter(withFormat dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    
    // Add
    func addNumberOfDays(_ days: Int) -> Date {
        return Date(timeInterval: TimeInterval(days * (60*60*24)), since: self)
    }
    
    
    // Returns date interval for specific date in given period type
    func getDateInterval(in type: PeriodType) -> DateInterval {
        let calendar = Calendar.userCurrentUTC()
        var component = Calendar.Component.second
        
        switch type {
        case .week, .customPeriod:
            component = .weekOfYear
        case .month:
            component = .month
        case .year, .sinceYouStarted:
            component = .year
        }
        
        var dateInterval = calendar.dateInterval(of: component, for: self) ?? DateInterval()
        dateInterval.end = dateInterval.end.addingTimeInterval(-0.1)
        return dateInterval
    }
}

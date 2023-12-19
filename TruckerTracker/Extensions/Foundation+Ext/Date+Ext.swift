//
//  Date+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/24/22.
//

import Foundation

extension Date {
    
    // Convert
    func convertToYearFormat() -> String {
        return formatted(.dateTime.year())
    }
    
    func converToMonthYearFormat() -> String {
        return formatted(.dateTime.month(.wide).year())
    }
    
    func convertToMonthDayFormat() -> String {
        return formatted(.dateTime.month().day())
    }
    
    func convertToMonthDayYearFormat() -> String {
        return formatted(.dateTime.month().day().year(.twoDigits))
    }
    
    // Add
    func addNumberOfYears(_ years: Int) -> Date {
        return Date(timeInterval: TimeInterval(years*(60*60*24*365)), since: self)
    }
    
    func addNumberOfDays(_ days: Int) -> Date {
        return Date(timeInterval: TimeInterval(days * (60*60*24)), since: self)
    }
    
    
    // Returns date interval for specific date in given period type
    func getDateInterval(in type: PeriodType) -> DateInterval {
        let calendar = Calendar.userCurrent()
        var component = Calendar.Component.weekOfYear
        
        switch type {
        case .week, .customPeriod:
            component = .weekOfYear
            
        case .month:
            component = .month
            
        case .year, .sinceYouStarted:
            component = .year
        }
        
        return calendar.dateInterval(of: component, for: self) ?? DateInterval()
    }
    
    // Components
    func yearNumber() -> Int {
        let calendar = Calendar.userCurrent()
        return calendar.component(.year, from: self)
    }
    
    
    func weekdayName() -> String {
        let calendar = Calendar.userCurrent()
        let weekdayIndex = calendar.component(.weekday, from: self)
        let weekdaySymbols = calendar.weekdaySymbols
        
        return weekdaySymbols[weekdayIndex - 1]
    }
    
    
    func dayNumberInYear() -> Int {
        let calendar = Calendar.userCurrent()
        return calendar.ordinality(of: .day, in: .year, for: self) ?? 0
    }
    
    // Local date
    func local() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second,
                                              value: Int(timeZoneOffset),
                                              to: self)
        return localDate ?? self
    }
}

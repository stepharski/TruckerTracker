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
        let calendar = Calendar.getCurrent()
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
    
    func getYear() -> Int {
        let calendar = Calendar.getCurrent()
        
        return calendar.component(.year, from: self)
    }
}

//
//  Period.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/24/23.
//

import Foundation

struct Period: Codable {
    
    var type: PeriodType
    var interval: DateInterval
    
    // Default
    static func getDefault() -> Period {
        let defaultType = UDValues.periodType
        let defaultInterval = Date().getDateInterval(in: defaultType)
        
        return Period(type: defaultType, interval: defaultInterval)
    }
    
    // String
    func convertToString() -> String {
        switch type {
        case .year:
            return interval.middleDate().convertToYearFormat()
            
        case .month:
            return interval.middleDate().converToMonthYearFormat()
            
        case .week, .sinceYouStarted, .customPeriod:
            return "\(interval.start.convertToMonthDayYearFormat()) － \(interval.end.convertToMonthDayYearFormat())"
        }
    }
}

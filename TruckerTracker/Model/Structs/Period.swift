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
    
    
    func convertToString() -> String {
        switch type {
        case .year:
            return interval.start.convertToYearFormat()
            
        case .month:
            return interval.start.converToMonthYearFormat()
            
        case .week, .sinceYouStarted, .customPeriod:
            return "\(interval.start.convertToMonthDayYearFormat()) － \(interval.end.convertToMonthDayYearFormat())"
        }
    }
}

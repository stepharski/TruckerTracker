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
        let defaultType = UDValues.dashboardPeriodType
        let defaultInterval = Date().getDateInterval(in: defaultType)
        
        return Period(type: defaultType, interval: defaultInterval)
    }
    
    // Current
    static func getCurrent() -> Period {
        let currentType = UDManager.shared.dashboardPeriodType
        let currentInterval = Date().getDateInterval(in: currentType)
        
        return Period(type: currentType, interval: currentInterval)
    }
    
    // String
    func convertToString() -> String {
        switch type {
        case .year:
            return interval.middleDate.convertToYearFormat()
            
        case .month:
            return interval.middleDate.converToMonthYearFormat()
            
        case .week, .sinceYouStarted, .customPeriod:
            let start = interval.start.convertToMonthDayYearFormat()
            let end = interval.end.convertToMonthDayYearFormat()
            return "\(start) － \(end)"
        }
    }
}

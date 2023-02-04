//
//  DateInterval+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/25/23.
//

import Foundation

extension DateInterval {
    
    func middleDate() -> Date {
        let middleStamp = start.timeIntervalSince1970 + duration / 2
        return Date(timeIntervalSince1970: middleStamp)
    }
    
    
    func nextInterval() -> DateInterval {
        return DateInterval(start: start.advanced(by: duration),
                                        duration: duration)
    }
    
    func previousInterval() -> DateInterval {
        return DateInterval(start: start.advanced(by: -duration),
                                        duration: duration)
    }
}

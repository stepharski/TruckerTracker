//
//  PeriodType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/24/23.
//

import Foundation

enum PeriodType: String, Codable {
    case year, month, week
    case customPeriod, sinceYouStarted
    
    var title: String {
        switch self {
        case .week, .month, .year:
            return self.rawValue.capitalized
        case .sinceYouStarted, .customPeriod:
            return self.rawValue.camelCaseToWords()
        }
    }
}

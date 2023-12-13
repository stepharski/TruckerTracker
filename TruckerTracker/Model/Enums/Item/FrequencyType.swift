//
//  FrequencyType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

enum FrequencyType: Int, CaseIterable {
    case oneTime
    case day, week, month, year
    
    var index: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .oneTime:  return "One time"
        case .day:     return "Every day"
        case .week:    return "Every week"
        case .month:   return "Every month"
        case .year:    return "Every year"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .oneTime:  return SFSymbols.creditCard
        default:       return SFSymbols.repeatArrows
        }
    }
}

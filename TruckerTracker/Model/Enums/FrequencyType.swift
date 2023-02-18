//
//  FrequencyType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

enum FrequencyType: String {
    case oneTime, day, week, month, year
    
    var title: String {
        switch self {
        case .oneTime:
            return "One time"
        default:
            return "Every " + self.rawValue
        }
    }
    
    var image: UIImage? {
        switch self {
        case .oneTime:
            return SFSymbols.creditCard
        default:
            return SFSymbols.repeatArrows
        }
    }
}

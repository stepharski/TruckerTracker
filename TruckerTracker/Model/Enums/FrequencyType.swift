//
//  FrequencyType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import Foundation

enum FrequencyType: String {
    case never, day, week, month, year
    
    var title: String {
        switch self {
        case .never:
            return self.rawValue.capitalized
        default:
            return "Every " + self.rawValue
        }
    }
}

//
//  ItemType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/9/23.
//

import Foundation

enum ItemType: String, CaseIterable {
    case expense, load, fuel
    
    var title: String {
        return self.rawValue
    }
    
    var pluralTitle: String {
        switch self {
        case .expense, .load:
            return "\(self.rawValue)s"
        case .fuel:
            return self.rawValue
        }
    }
    
    var index: Int {
        switch self {
        case .expense:
            return 0
        case .load:
            return 1
        case .fuel:
            return 2
        }
    }
}

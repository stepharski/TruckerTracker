//
//  ItemPickerType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/23/22.
//

import Foundation

enum PickerType {
    case date, frequency, fuel
    
    var itemTypes: [PickerItemType] {
        switch self {
        case .date:
            return []
        case .frequency:
            return [.never, .day, .week, .month, .year]
        case .fuel:
            return [.diesel, .def, .gas]
        }
    }
}

enum PickerItemType: String {
    case diesel, def, gas
    case never, day, week, month, year
}

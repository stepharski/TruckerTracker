//
//  LoadViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit

// MARK: - LoadViewModelItemType
enum LoadViewModelItemType {
    case tripDistance
    case emptyDistance
    case date
    case startLocation
    case endLocation
    case documents
}

// MARK: - LoadViewModelItem
protocol LoadViewModelItem {
    var type: LoadViewModelItemType { get }
    var rowCount: Int { get }
}

extension LoadViewModelItem {
    var rowCount: Int { return 1 }
}

// MARK: - LoadViewModel
class LoadViewModel {
    var items = [LoadViewModelItem]()
    
    init(_ load: Load?) {
        let model = load ?? Load.getDefault()
        
        items.append(LoadViewModelTripDistanceItem(distance: model.distance))
        items.append(LoadViewModelEmptyDistanceItem(distance: model.emptyDistance ?? 0))
        items.append(LoadViewModelDateItem(date: model.date))
        items.append(LoadViewModelStartLocationItem(startLocation: model.startLocation))
        items.append(LoadViewModelEndLocationItem(endLocation: model.endLocation))
        items.append(LoadViewModelDocumentsItem(documents: model.documents ?? []))
    }
}

// Trip miles
class LoadViewModelTripDistanceItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .tripDistance
    var image: UIImage? = SFSymbols.roadLanes
    var title: String = "Trip distance"
    var distance: Int
    
    var distanceAbbreviation: String {
        return UDManager.shared.getDistanceType().abbreviation
    }
    
    init(distance: Int) {
        self.distance = distance
    }
}

// Empty miles
class LoadViewModelEmptyDistanceItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .emptyDistance
    var image: UIImage? = SFSymbols.roadLanesEmpty
    var title: String = "Empty distance"
    var distance: Int
    
    var distanceAbbreviation: String {
        return UDManager.shared.getDistanceType().abbreviation
    }
    
    init(distance: Int) {
        self.distance = distance
    }
}

// Date
class LoadViewModelDateItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .date
    var date: Date
    
    var title: String {
        return Calendar.current.isDateInToday(date) ? "Today" : date.convertToMonthDayFormat()
    }
    
    init(date: Date) {
        self.date = date
    }
}

// Start location
class LoadViewModelStartLocationItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .startLocation
    var title: String = "From"
    var startLocation: String
    
    init(startLocation: String) {
        self.startLocation = startLocation
    }
}

// End location
class LoadViewModelEndLocationItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .endLocation
    var title: String = "To"
    var endLocation: String
    
    init(endLocation: String) {
        self.endLocation = endLocation
    }
}

// Documents
class LoadViewModelDocumentsItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .documents
    var rowCount: Int { return documents.count }
    var sectionTitle: String = "Documents"
    var documents: [String]
    
    init(documents: [String]) {
        self.documents = documents
    }
}

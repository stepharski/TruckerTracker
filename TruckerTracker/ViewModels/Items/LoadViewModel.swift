//
//  LoadViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit

// MARK: - LoadViewModelItemType
enum LoadViewModelItemType {
    case emptyDistance
    case tripDistance
    case date
    case startLocation
    case endLocation
    case attachments
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
        let model = load ?? Load.getEmpty()
        
        items.append(LoadViewModelEmptyDistanceItem(distance: model.emptyDistance ?? 0))
        items.append(LoadViewModelTripDistanceItem(distance: model.distance))
        items.append(LoadViewModelDateItem(date: model.date))
        items.append(LoadViewModelStartLocationItem(startLocation: model.startLocation))
        items.append(LoadViewModelEndLocationItem(endLocation: model.endLocation))
        items.append(LoadViewModelAttachmentsItem(attachments: model.attachments ?? []))
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

// Date
class LoadViewModelDateItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .date
    var date: Date
    
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

// Attachments
class LoadViewModelAttachmentsItem: LoadViewModelItem {
    var type: LoadViewModelItemType = .attachments
    var rowCount: Int { return hasAttachments ? attachments.count : 1 }
    var hasAttachments: Bool { return attachments.count > 0 }
    var attachments: [String]
    
    init(attachments: [String]) {
        self.attachments = attachments
    }
}

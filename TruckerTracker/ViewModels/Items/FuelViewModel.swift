//
//  FuelViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit

// MARK: - FuelViewModelItemType
enum FuelViewModelItemType {
    case location
    case date
    case diesel
    case def
    case reefer
    case attachments
}

// MARK: - FuelViewModelItemType
protocol FuelViewModelItem {
    var type: FuelViewModelItemType { get }
    var rowCount: Int { get }
}

extension FuelViewModelItem {
    var rowCount: Int { return 1 }
}

// MARK: - FuelViewModel
class FuelViewModel {
    var items = [FuelViewModelItem]()
    
    init(_ fuel: Fuel?) {
        let model = fuel ?? Fuel.getEmpty()
        
        items.append(FuelViewModelLocationItem(location: model.location ?? ""))
        items.append(FuelViewModelDateItem(date: model.date))
        items.append(FuelViewModelDieselItem(amount: model.dieselAmount))
        items.append(FuelViewModelDefItem(amount: model.defAmount ?? 0))
        items.append(FuelViewModelReeferItem(amount: model.reeferAmount ?? 0))
        items.append(FuelViewModelAttachmentsItem(attachments: model.attachments ?? []))
    }
}

// Location
class FuelViewModelLocationItem: FuelViewModelItem {
    var type: FuelViewModelItemType = .location
    var location: String
    
    init(location: String) {
        self.location = location
    }
}

// Date
class FuelViewModelDateItem: FuelViewModelItem {
    var type: FuelViewModelItemType = .date
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
}

// Diesel
class FuelViewModelDieselItem: FuelViewModelItem {
    var type: FuelViewModelItemType = .diesel
    var image: UIImage? = SFSymbols.fuelPumpFill
    var title: String = "Diesel"
    var amount: Double
    
    init(amount: Double) {
        self.amount = amount
    }
}

// Def
class FuelViewModelDefItem: FuelViewModelItem {
    var type: FuelViewModelItemType = .def
    var image: UIImage? = SFSymbols.dropFill
    var title: String = "DEF"
    var amount: Double
    
    init(amount: Double) {
        self.amount = amount
    }
}

// Reefer
class FuelViewModelReeferItem: FuelViewModelItem {
    var type: FuelViewModelItemType = .reefer
    var image: UIImage? = SFSymbols.snowflake
    var title: String = "Reefer"
    var amount: Double
    
    init(amount: Double) {
        self.amount = amount
    }
}

// Attachments
class FuelViewModelAttachmentsItem: FuelViewModelItem {
    var type: FuelViewModelItemType = .attachments
    var rowCount: Int { return hasAttachments ? attachments.count : 1}
    var hasAttachments: Bool { return attachments.count > 0 }
    var attachments: [String]
    
    init(attachments: [String]) {
        self.attachments = attachments
    }
}

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
        let model = fuel ?? Fuel.getDefault()
        
        items.append(FuelViewModelLocationItem(location: model.location ?? ""))
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
    var gallons: Double {  return amount / price }
    var amount: Double
    var price: Double
    
    init(amount: Double, price: Double) {
        self.amount = amount
        self.price = price
    }
}

// Def
class FuelViewModelDefItemType: FuelViewModelItem {
    var type: FuelViewModelItemType = .def
    var gallons: Double {  return amount / price }
    var amount: Double
    var price: Double
    
    init(amount: Double, price: Double) {
        self.amount = amount
        self.price = price
    }
}

// Reefer
class FuelViewModelReeferItemType: FuelViewModelItem {
    var type: FuelViewModelItemType = .reefer
    var gallons: Double {  return amount / price }
    var amount: Double
    var price: Double
    
    init(amount: Double, price: Double) {
        self.amount = amount
        self.price = price
    }
}

// Attachments
class FuelViewModelAttachemntsItemType: FuelViewModelItem {
    var type: FuelViewModelItemType = .attachments
    var rowCount: Int { return attachments.count }
    var sectionTitle: String = "Attachments"
    var attachments: [String]
    
    init(attachments: [String]) {
        self.attachments = attachments
    }
}

//
//  FuelTableViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit
import CoreData

// MARK: - Type
enum FuelTableSectionType {
    case location
    case date
    case diesel
    case def
    case reefer
    case attachments
}

protocol FuelTableSection {
    var type: FuelTableSectionType { get }
    var rowCount: Int { get }
}

extension FuelTableSection {
    var rowCount: Int { return 1 }
}

// MARK: - FuelTable ViewModel
class FuelTableViewModel {
    
    private var fuel: Fuel
    private let dataManager = CoreDataManager.shared
    private let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    var sections = [FuelTableSection]()
    var sectionToReload: Observable<FuelTableSectionType?> = Observable(nil)
    var totalFuelAmount: Observable<Double> = Observable(0)
    
    // Init
    init(_ fuel: Fuel?) {
        self.fuel = fuel ?? dataManager.createEmptyFuel(with: childContext)
        self.totalFuelAmount.value = self.fuel.totalAmount
        
        sections.append(FuelTableLocationSection(self.fuel.location))
        sections.append(FuelTableDateSection(self.fuel.date))
        sections.append(FuelTableDieselSection(self.fuel.dieselAmount))
        sections.append(FuelTableDefSection(self.fuel.defAmount))
        sections.append(FuelTableReeferSection(self.fuel.reeferAmount))
    }
}

// MARK: - Sections updates
extension FuelTableViewModel {
    // Section Index
    func getIndex(of sectionType: FuelTableSectionType) -> Int? {
        return sections.firstIndex(where: { $0.type == sectionType })
    }
    
    // Updates
    func updateRequestedLocation(_ location: String) {
        updateLocation(location)
        sectionToReload.value = .location
    }
    
    func updateLocation(_ location: String) {
        if let locationSection = sections.first(where: { $0.type == .location })
                                                    as? FuelTableLocationSection {
            self.fuel.location = location
            locationSection.location = location
        }
    }
    
    func updateDate(_ date: Date) {
        if let dateSection = sections.first(where: { $0.type == .date })
                                                as? FuelTableDateSection {
            self.fuel.date = date
            dateSection.date = date
            sectionToReload.value = .date
        }
    }
    
    func distributeTotalAmountChange(_ amount: Double) {
        guard amount != totalFuelAmount.value else { return }
        
        updateDieselAmount(amount)
        sectionToReload.value = .diesel
        
        updateDefAmount(0)
        sectionToReload.value = .def
        
        updateReeferAmount(0)
        sectionToReload.value = .reefer
        
        self.fuel.totalAmount = amount
    }
    
    func updateDieselAmount(_ amount: Double) {
        if let dieselSection = sections.first(where: { $0.type == .diesel })
                                                as? FuelTableDieselSection {
            self.fuel.dieselAmount = amount
            dieselSection.amount = amount
            updateTotalAmount()
        }
    }
    
    func updateDefAmount(_ amount: Double) {
        if let defSection = sections.first(where: { $0.type == .def })
                                                as? FuelTableDefSection {
            self.fuel.defAmount = amount
            defSection.amount = amount
            updateTotalAmount()
        }
    }
    
    func updateReeferAmount(_ amount: Double) {
        if let reeferSection = sections.first(where: { $0.type == .reefer })
                                                as? FuelTableReeferSection {
            self.fuel.reeferAmount = amount
            reeferSection.amount = amount
            updateTotalAmount()
        }
    }
    
    private func updateTotalAmount() {
        self.fuel.totalAmount = fuel.dieselAmount + fuel.defAmount + fuel.reeferAmount
        totalFuelAmount.value = fuel.totalAmount
    }
}

// MARK: - Core Data Operations
extension FuelTableViewModel {
    func save() -> Result<Void, Error> {
        do {
            try childContext.save()
            try dataManager.saveChanges()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func delete() -> Result<Void, Error> {
        do {
            try dataManager.delete(fuel)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Sections
// Location
class FuelTableLocationSection: FuelTableSection {
    var type: FuelTableSectionType = .location
    var location: String
    
    init(_ location: String) {
        self.location = location
    }
}

// Date
class FuelTableDateSection: FuelTableSection {
    var type: FuelTableSectionType = .date
    var date: Date
    
    init(_ date: Date) {
        self.date = date
    }
}

// Diesel
class FuelTableDieselSection: FuelTableSection {
    var type: FuelTableSectionType = .diesel
    var image: UIImage? = SFSymbols.fuelPumpFill
    var title: String = "Diesel"
    var amount: Double
    
    init(_ amount: Double) {
        self.amount = amount
    }
}

// Def
class FuelTableDefSection: FuelTableSection {
    var type: FuelTableSectionType = .def
    var image: UIImage? = SFSymbols.dropFill
    var title: String = "DEF"
    var amount: Double
    
    init(_ amount: Double) {
        self.amount = amount
    }
}

// Reefer
class FuelTableReeferSection: FuelTableSection {
    var type: FuelTableSectionType = .reefer
    var image: UIImage? = SFSymbols.snowflake
    var title: String = "Reefer"
    var amount: Double
    
    init(_ amount: Double) {
        self.amount = amount
    }
}

// Attachments
class FuelTableAttachmentsSection: FuelTableSection {
    var type: FuelTableSectionType = .attachments
    var rowCount: Int { return hasAttachments ? attachments.count : 1}
    var hasAttachments: Bool { return attachments.count > 0 }
    var attachments: [String]
    
    init(_ attachments: [String]) {
        self.attachments = attachments
    }
}

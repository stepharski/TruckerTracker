//
//  LoadTableViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit
import CoreData

//MARK: - Type
enum LoadTableSectionType {
    case tripDistance
    case date
    case startLocation
    case endLocation
    case attachments
}

protocol LoadTableSection {
    var type: LoadTableSectionType { get }
    var rowCount: Int { get }
}

extension LoadTableSection {
    var rowCount: Int { return 1 }
}

// MARK: - LoadTable ViewModel
class LoadTableViewModel {
    
    private var load: Load
    private let dataManager = CoreDataManager.shared
    private let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    var sections = [LoadTableSection]()
    var sectionToReload: Observable<LoadTableSectionType?> = Observable(nil)
    var requestedLocation: LoadTableSectionType?
    
    // Init
    init(_ load: Load?) {
        self.load = load ?? dataManager.createEmptyLoad(in: childContext)
        
        sections.append(LoadTableTripDistanceSection(Int(self.load.distance)))
        sections.append(LoadTableDateSection(self.load.date))
        sections.append(LoadTableStartLocationSection(self.load.startLocation))
        sections.append(LoadTableEndLocationSection(self.load.endLocation))
    }
}

// MARK: - Sections updates
extension LoadTableViewModel {
    // Section Index
    func getIndex(of sectionType: LoadTableSectionType) -> Int? {
        return sections.firstIndex(where: { $0.type == sectionType })
    }
    
    // Updates
    func updateTripDistance(_ distance: Int) {
        if let tripDistanceSection = sections.first(where: { $0.type == .tripDistance })
                                                        as? LoadTableTripDistanceSection {
            self.load.distance = Int64(distance)
            tripDistanceSection.distance = distance
        }
    }
    
    func updateDate(_ date: Date) {
        if let dateSection = sections.first(where: { $0.type == .date }) as? LoadTableDateSection {
            self.load.date = date
            dateSection.date = date
            sectionToReload.value = .date
        }
    }
    
    func updateRequestedLocation(_ location: String) {
        guard let requestedLocation = requestedLocation else { return }
        
        switch requestedLocation {
        case .startLocation:
            updateStartLocation(location)
            sectionToReload.value = .startLocation
        case .endLocation:
            updateEndLocation(location)
            sectionToReload.value = .endLocation
        default: break
        }
    }
    
    func updateStartLocation(_ location: String) {
        if let startLocationSection = sections.first(where: { $0.type == .startLocation })
                                                        as? LoadTableStartLocationSection {
            self.load.startLocation = location
            startLocationSection.startLocation = location
        }
    }
    
    func updateEndLocation(_ location: String) {
        if let endLocationSection = sections.first(where: { $0.type == .endLocation })
                                                        as? LoadTableEndLocationSection {
            self.load.endLocation = location
            endLocationSection.endLocation = location
        }
    }
}

// MARK: - Core Data Operations
extension LoadTableViewModel {
    // Validation
    func validateSections() -> ValidationError? {
        guard self.load.distance > 0 else { return .loadNullDistance }
        guard self.load.startLocation.hasContent() else { return .loadNoStartLocation }
        guard self.load.endLocation.hasContent() else { return .loadNoEndLocation }
        
        return nil
    }
    
    // Save
    func save(with amount: Double) -> Result<Void, Error> {
        do {
            load.amount = amount
            try childContext.save()
            try dataManager.saveChanges()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // Delete
    func delete() -> Result<Void, Error> {
        do {
            try dataManager.delete(load)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Sections
// Trip miles
class LoadTableTripDistanceSection: LoadTableSection {
    var type: LoadTableSectionType = .tripDistance
    var distance: Int
    
    var distanceAbbreviation: String {
        return UDManager.shared.distanceUnit.abbreviation
    }
    
    init(_ distance: Int) {
        self.distance = distance
    }
}

// Date
class LoadTableDateSection: LoadTableSection {
    var type: LoadTableSectionType = .date
    var date: Date
    
    init(_ date: Date) {
        self.date = date
    }
}

// Start location
class LoadTableStartLocationSection: LoadTableSection {
    var type: LoadTableSectionType = .startLocation
    var title: String = "From"
    var startLocation: String
    
    init(_ startLocation: String) {
        self.startLocation = startLocation
    }
}

// End location
class LoadTableEndLocationSection: LoadTableSection {
    var type: LoadTableSectionType = .endLocation
    var title: String = "To"
    var endLocation: String
    
    init(_ endLocation: String) {
        self.endLocation = endLocation
    }
}

// Attachments
class LoadTableAttachmentsSection: LoadTableSection {
    var type: LoadTableSectionType = .attachments
    var rowCount: Int { return hasAttachments ? attachments.count : 1 }
    var hasAttachments: Bool { return attachments.count > 0 }
    var attachments: [String]
    
    init(_ attachments: [String]) {
        self.attachments = attachments
    }
}

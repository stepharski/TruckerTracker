//
//  LoadTableViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit

//MARK: - Type
enum LoadTableSectionType {
    case emptyDistance
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
    var sections = [LoadTableSection]()
    
    var sectionToReload: Observable<LoadTableSectionType?> = Observable(nil)
    var requestedLocation: LoadTableSectionType?
    
    // Init
    init(_ load: Load) {
        self.load = load
        sections.append(LoadTableEmptyDistanceSection(Int(load.emptyDistance)))
        sections.append(LoadTableTripDistanceSection(Int(load.distance)))
        sections.append(LoadTableDateSection(load.date))
        sections.append(LoadTableStartLocationSection(load.startLocation))
        sections.append(LoadTableEndLocationSection(load.endLocation))
        //TODO: Handle Attachments
//        sections.append(LoadTableAttachmentsSection(load.attachments ?? []))
    }
    
    // Section Index
    func getIndex(of sectionType: LoadTableSectionType) -> Int? {
        return sections.firstIndex(where: { $0.type == sectionType })
    }
    
    // Section Updates
    func updateEmptyDistance(_ distance: Int) {
        if let emptyDistanceSection = sections.first(where: { $0.type == .emptyDistance })
                                                        as? LoadTableEmptyDistanceSection {
            self.load.emptyDistance = Int64(distance)
            emptyDistanceSection.distance = distance
        }
    }
    
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
    
    func updateAttachments(_ attachments: [String]) {
        //TODO: Update Attachments
//        if let attachmentsSection = sections.first(where: { $0.type == .attachments })
//                                                    as? LoadTableAttachmentsSection {
//            self.load.attachments = attachments
//            attachmentsSection.attachments = attachments
//            sectionToReload.value = .attachments
//        }
    }
    
    // Save
    func saveItem() {
        
    }
    
    // Validation
    func validateSections() -> ValidationError? {
        guard self.load.distance > 0 else { return .nullDistance }
        guard self.load.startLocation.hasContent() else { return .emptyStartLocation }
        guard self.load.endLocation.hasContent() else { return .emptyEndLocation }
        
        return nil
    }
}

// MARK: - Sections
// Empty miles
class LoadTableEmptyDistanceSection: LoadTableSection {
    var type: LoadTableSectionType = .emptyDistance
    var image: UIImage? = SFSymbols.roadLanesEmpty
    var title: String = "Empty distance"
    var distance: Int
    
    var distanceAbbreviation: String {
        return UDManager.shared.distanceUnit.abbreviation
    }
    
    init(_ distance: Int) {
        self.distance = distance
    }
}

// Trip miles
class LoadTableTripDistanceSection: LoadTableSection {
    var type: LoadTableSectionType = .tripDistance
    var image: UIImage? = SFSymbols.roadLanes
    var title: String = "Trip distance"
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

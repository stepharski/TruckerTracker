//
//  Load+CoreDataProperties.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/22/23.
//
//

import Foundation
import CoreData


extension Load {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Load> {
        return NSFetchRequest<Load>(entityName: "Load")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var amount: Double
    @NSManaged public var distance: Int64
    @NSManaged public var emptyDistance: Int64
    @NSManaged public var startLocation: String
    @NSManaged public var endLocation: String

}

extension Load: Identifiable { }

//
//  Fuel+CoreDataProperties.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/7/24.
//
//

import Foundation
import CoreData


extension Fuel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fuel> {
        return NSFetchRequest<Fuel>(entityName: "Fuel")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var location: String
    @NSManaged public var defAmount: Double
    @NSManaged public var dieselAmount: Double
    @NSManaged public var reeferAmount: Double
    @NSManaged public var totalAmount: Double
}

extension Fuel : Identifiable { }

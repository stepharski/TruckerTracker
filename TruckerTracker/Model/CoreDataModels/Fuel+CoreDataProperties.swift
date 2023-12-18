//
//  Fuel+CoreDataProperties.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/13/23.
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

    var totalAmount: Double {
        return dieselAmount + defAmount + reeferAmount
    }
}

extension Fuel : Identifiable { }

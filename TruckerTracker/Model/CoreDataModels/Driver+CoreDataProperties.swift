//
//  Driver+CoreDataProperties.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/17/24.
//
//

import Foundation
import CoreData


extension Driver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Driver> {
        return NSFetchRequest<Driver>(entityName: "Driver")
    }

    @NSManaged public var id: UUID
    @NSManaged public var isTeam: Bool
    @NSManaged public var name: String
    @NSManaged public var payRate: Int64

}

extension Driver : Identifiable { }

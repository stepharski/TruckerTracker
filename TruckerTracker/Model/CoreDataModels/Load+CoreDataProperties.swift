//
//  Load+CoreDataProperties.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/8/24.
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
    @NSManaged public var grossAmount: Double
    @NSManaged public var earningsAmount: Double
    @NSManaged public var distance: Int64
    @NSManaged public var startLocation: String
    @NSManaged public var endLocation: String
    
}

extension Load : Identifiable { }

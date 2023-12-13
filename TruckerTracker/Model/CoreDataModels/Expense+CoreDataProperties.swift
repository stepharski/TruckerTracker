//
//  Expense+CoreDataProperties.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/12/23.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var amount: Double
    @NSManaged public var name: String
    @NSManaged public var note: String
    @NSManaged fileprivate var frequencyValue: Int64
    
    var frequency: FrequencyType {
        get { return FrequencyType(rawValue: Int(frequencyValue)) ?? .oneTime }
        set { frequencyValue = Int64(newValue.rawValue) }
    }

}

extension Expense : Identifiable { }

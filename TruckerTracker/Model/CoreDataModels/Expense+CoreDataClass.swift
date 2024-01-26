//
//  Expense+CoreDataClass.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/12/23.
//
//

import Foundation
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {

    // Custom init
    public init(context: NSManagedObjectContext,
                id: UUID = UUID(),
                date: Date = Date(),
                name: String = "",
                note: String = "",
                amount: Double = 0,
                frequencyIndex: Int = 0) {
        let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.date = date.local
        self.name = name
        self.note = note
        self.amount = amount
        self.frequency = FrequencyType(rawValue: frequencyIndex) ?? .oneTime
    }
    
    @objc
    override private init(entity: NSEntityDescription,
                        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    
    // Forbiden invalid init
    @available(*, unavailable)
    public init() {
        fatalError("\(#function) not implemented")
    }
    
    @available(*, unavailable)
    public convenience init(context: NSManagedObjectContext) {
        fatalError("\(#function) not implemented")
    }
}

//
//  Fuel+CoreDataClass.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/7/24.
//
//

import Foundation
import CoreData

@objc(Fuel)
public class Fuel: NSManagedObject {

    // Custom init
    public init(context: NSManagedObjectContext,
                id: UUID = UUID(),
                date: Date = Date(),
                location: String = "",
                defAmount: Double = 0,
                dieselAmount: Double = 0,
                reeferAmount: Double = 0,
                totalAmount: Double = 0) {
        let entity = NSEntityDescription.entity(forEntityName: "Fuel", in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.date = date.local
        self.location = location
        self.defAmount = defAmount
        self.dieselAmount = dieselAmount
        self.reeferAmount = reeferAmount
        self.totalAmount = totalAmount
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

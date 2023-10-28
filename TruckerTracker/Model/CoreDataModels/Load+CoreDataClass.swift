//
//  Load+CoreDataClass.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/28/23.
//
//

import Foundation
import CoreData

@objc(Load)
public class Load: NSManagedObject {
    
    // Custom init
    public init(context: NSManagedObjectContext,
                id: UUID = UUID(),
                date: Date = Date(),
                amount: Double = 0,
                distance: Int64 = 0,
                startLocation: String = "",
                endLocation: String = "") {
        let entity = NSEntityDescription.entity(forEntityName: "Load", in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.date = date
        self.amount = amount
        self.distance = distance
        self.startLocation = startLocation
        self.endLocation = endLocation
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

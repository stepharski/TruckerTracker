//
//  Driver+CoreDataClass.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/17/24.
//
//

import Foundation
import CoreData

@objc(Driver)
public class Driver: NSManagedObject {

    // Custom init
    public init(context: NSManagedObjectContext,
                id: UUID = UUID(),
                name: String = "",
                isTeam: Bool = false,
                payRate: Int = 88) {
        let entity = NSEntityDescription.entity(forEntityName: "Driver", in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
        self.isTeam = isTeam
        self.payRate = Int64(payRate)
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

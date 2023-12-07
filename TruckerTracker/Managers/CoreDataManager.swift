//
//  CoreDataManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/11/23.
//

import Foundation
import CoreData

//MARK: - Core Data Manager
class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TruckerTracker")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Couldn't load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func saveChanges() throws {
        if mainContext.hasChanges {
            try mainContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) throws {
        //TODO: Consider adding perfrom and wait
        mainContext.delete(object)
        try saveChanges()
    }
}

// MARK: - Load entity functions
extension CoreDataManager {
    
    func createEmptyLoad(in childContext: NSManagedObjectContext) -> Load {
        childContext.parent = mainContext
        return Load(context: childContext)
    }
    
    func fetchLoads(for period: Period) throws -> [Load] {
        let request = Load.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@",
                            argumentArray: [period.interval.start, period.interval.end])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Load.date, ascending: true)]
        
        do { return try mainContext.fetch(request) }
        catch let error { throw error }
    }
}

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
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func saveChanges() {
        if viewContext.hasChanges {
            do { try viewContext.save() }
            catch { fatalError("Error while saving context: \(error.localizedDescription)") }
        }
    }
}

// MARK: - Load entity functions
extension CoreDataManager {
    
    func createEmptyLoad(in childContext: NSManagedObjectContext) -> Load {
        childContext.parent = viewContext
        return Load(context: childContext)
    }
    
    func deleteLoad(_ load: Load) {
        viewContext.delete(load)
        saveChanges()
    }
    
    
    func fetchLoads(for period: Period) throws -> [Load] {
        let request = Load.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@",
                            argumentArray: [period.interval.start, period.interval.end])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Load.date, ascending: true)]
        
        do { return try viewContext.fetch(request) }
        catch let error { throw error }
    }
}

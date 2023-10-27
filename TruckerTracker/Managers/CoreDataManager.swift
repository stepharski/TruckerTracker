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
    
    private func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("An error occured while saving context: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Load entity functions
extension CoreDataManager {
    func createEmptyLoad() -> Load {
        return Load(context: viewContext)
    }
    
    func saveLoad() {
        save()
    }
    
    func deleteLoad(_ load: Load) {
        viewContext.delete(load)
        save()
    }
    
    func fetchLoads(filter: String? = nil) -> [Load] {
        let request = Load.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(keyPath: \Load.date, ascending: false)
        request.sortDescriptors = [dateSortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "date between {$YESTERDAY, $TOMORROW}", filter)
            request.predicate = predicate
        }
        
        //TODO: Rewrite in more friendly way
        return (try? viewContext.fetch(request)) ?? []
    }
}

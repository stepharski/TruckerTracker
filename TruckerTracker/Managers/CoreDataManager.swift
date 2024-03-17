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
    private(set) var cachedDriver: Driver?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TruckerTracker")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("\(OperationError.persistentStoresError)") }
        }
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    // Save
    func saveChanges() throws {
        if mainContext.hasChanges {
            try mainContext.save()
        }
    }
    
    // Delete
    func delete(_ object: NSManagedObject) throws {
        mainContext.delete(object)
        try saveChanges()
    }
}


// MARK: - Driver entity functions
extension CoreDataManager {
    // Fetch + Cache
    func fetchAndCacheDriver() throws {
        cachedDriver = try fetchExistingDriver() ?? createNewDriver()
    }
    
    // Fetch driver
    private func fetchExistingDriver() throws -> Driver? {
        let request = Driver.fetchRequest()
        do { return try mainContext.fetch(request).first }
        catch { throw error }
    }
    
    // Create driver
    private func createNewDriver() throws -> Driver {
        do {
            let newDriver = Driver(context: mainContext)
            try mainContext.save()
            return newDriver
        } catch { throw error }
    }
}


// MARK: - Expense, Load, Fuel common functions
extension CoreDataManager {
    // Common fetch
    private func fetchEntities<T: NSManagedObject>(entityType: T.Type, in period: Period) throws -> [T] {
        let request = T.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@",
                                argumentArray: [period.interval.start, period.interval.end])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Load.date, ascending: false)]

        do { return try mainContext.fetch(request) as? [T] ?? [] }
        catch { throw error }
    }
    
    // Aggregate functions
    private func fetchSumAmountForEntities<T: NSManagedObject>(type: T.Type, in period: Period,
                                                             key: String) throws -> Double {
        // Create request
        let request = T.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@",
                                argumentArray: [period.interval.start, period.interval.end])
        // Add expression description
        let sumDescription = createSumDescription(for: key)
        request.propertiesToFetch = [sumDescription]
        request.resultType = .dictionaryResultType

        do { let result = try mainContext.fetch(request) as? [[String: Any]]
            return result?.first?["sum"] as? Double ?? 0 }
        catch { throw error }
    }
    
    // Sum expression
    private func createSumDescription(for key: String) -> NSExpressionDescription {
        let keyPathExp = NSExpression(forKeyPath: key)
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [keyPathExp])
        let sumDescription = NSExpressionDescription()
        sumDescription.expression = sumExpression
        sumDescription.name = "sum"
        sumDescription.expressionResultType = .doubleAttributeType
        
        return sumDescription
    }
}


// MARK: - Expense entity functions
extension CoreDataManager {
    
    func createEmptyExpense(with childContext: NSManagedObjectContext) -> Expense {
        childContext.parent = mainContext
        return Expense(context: childContext)
    }
    
    func fetchExpenses(in period: Period) throws -> [Expense] {
        do { return try fetchEntities(entityType: Expense.self, in: period) }
        catch { throw error }
    }
    
    func fetchExpensesSumAmount(in period: Period) throws -> Double {
        do { return try fetchSumAmountForEntities(type: Expense.self, in: period, key: "amount") }
        catch { throw error }
    }
}


// MARK: - Load entity functions
extension CoreDataManager {
    
    func createEmptyLoad(with childContext: NSManagedObjectContext) -> Load {
        childContext.parent = mainContext
        return Load(context: childContext)
    }
    
    func fetchLoads(in period: Period) throws -> [Load] {
        do { return try fetchEntities(entityType: Load.self, in: period) }
        catch { throw error }
    }
    
    func fetchLoadsSumAmount(in period: Period) throws -> Double {
        do { return try fetchSumAmountForEntities(type: Load.self, in: period, key: "grossAmount") }
        catch { throw error }
    }
}

// MARK: - Fuel entity functions
extension CoreDataManager {
    
    func createEmptyFuel(with childContext: NSManagedObjectContext) -> Fuel {
        childContext.parent = mainContext
        return Fuel(context: childContext)
    }
    
    func fetchFuelings(in period: Period) throws -> [Fuel] {
        do { return try fetchEntities(entityType: Fuel.self, in: period) }
        catch { throw error }
    }
    
    func fetchFuelingsSumAmount(in period: Period) throws -> Double {
        do { return try fetchSumAmountForEntities(type: Fuel.self, in: period, key: "totalAmount") }
        catch { throw error }
    }
}

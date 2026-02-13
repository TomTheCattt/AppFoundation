//
//  CoreDataStorage.swift
//  BaseIOSCore
//
//  Created by BaseIOSApp Package.
//

import Foundation
import CoreData

// Note: PersistenceProtocol uses Data for everything (Key-Value style).
// CoreData is Relational/Object Graph.
// Constructing a direct map from PersistenceProtocol to CoreData is tricky without a specific Entity.
// Here we assume a generic "CacheEntity" with key/value attributes exists if used as a Cache.
// OR we provide helper generic methods for fetching NSManagedObjects.

public class CoreDataStorage {
    private let context = CoreDataStack.shared.context
    
    public init() {}
    
    // Generic Fetch
    public func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            Logger.shared.error("CoreData fetch error: \(error)")
            return []
        }
    }
    
    // Generic Save
    public func save() {
        CoreDataStack.shared.saveContext()
    }
    
    // Generic Delete
    public func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
}

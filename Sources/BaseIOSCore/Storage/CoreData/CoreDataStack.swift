//
//  CoreDataStack.swift
//  BaseIOSCore
//
//  Created by BaseIOSApp Package.
//

import CoreData

public final class CoreDataStack {
    public static let shared = CoreDataStack()
    
    public var modelName: String = "BaseIOSAppModel" // Consumer should set this
    
    private init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                Logger.shared.error("CoreDataStack: Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                Logger.shared.error("CoreDataStack: Save error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

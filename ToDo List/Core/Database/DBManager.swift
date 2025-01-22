//
//  DataManager.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/17/25.
//

import Foundation
import CoreData

class DBManager {

    static let shared = DBManager()

    lazy var viewContext: NSManagedObjectContext = {
        self.container.viewContext
    }()


    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo")

        container.loadPersistentStores { (_, err) in
            if let err = err as NSError? {
                fatalError("Failed to load a stores: \(err.localizedDescription)")
            }
        }
        return container
    }()

    // Синглтон
    private init() {}

    func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { backgroundContext in
            backgroundContext.automaticallyMergesChangesFromParent = true
            task(backgroundContext)
        }
    }


    func first<T: NamedDBEntity>(entity: T.Type, byId id: UUID, context: NSManagedObjectContext) throws-> T? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T._entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        return try context.fetch(fetchRequest).first as? T
    }


    func delete<T: NamedDBEntity>(entity: T.Type, byID id: UUID, context: NSManagedObjectContext) throws -> Bool {

        guard let object = try first(entity: entity, byId: id, context: context) else {
            return false
        }

        context.delete(object)
        return true
    }


    func list<T: NamedDBEntity>(
        entity: T.Type, predicate: NSPredicate? = nil, context: NSManagedObjectContext) throws -> [T] {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T._entityName)
            if let predicate = predicate {
                fetchRequest.predicate = predicate
            }

            return try context.fetch(fetchRequest) as? [T] ?? []
        }
}


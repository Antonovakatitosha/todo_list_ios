//
//  DataManager.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/17/25.
//

import Foundation
import CoreData

// DBManager
class DataManager {

    static let shared = DataManager()

// Так как по ТЗ мы все операции с бд проводем в фоновыом потоке, то от спользования главного контекста сознательно отказываемся
//    lazy var viewContext: NSManagedObjectContext = {
//        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//        return self.container.viewContext
//    }()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo")

        container.loadPersistentStores { (_, err) in
            if let err = err as NSError? {
                print("Error when load stores:", err)
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


    func first<T: NamedDBEntity>(entity: T.Type, byId id: UUID, context: NSManagedObjectContext) -> T? {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T._entityName)
            fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            fetchRequest.fetchLimit = 1

            do {
                return try context.fetch(fetchRequest).first as? T
            } catch {
                print(error)
                return nil
            }
        }


    func delete<T: NamedDBEntity>(entity: T.Type, byId id: UUID, context: NSManagedObjectContext) -> Bool {

        if let object = first(entity: entity, byId: id, context: context) {
            context.delete(object)
            return true
        } else {
            print("Объект с id \(id) не найден.")
            return false
        }
    }



    func list<T: NamedDBEntity>(
        entity: T.Type, predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T._entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        return (try? context.fetch(fetchRequest) as? [T]) ?? []
    }
}


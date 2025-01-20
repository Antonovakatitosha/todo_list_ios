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

// Так как по ТЗ мы все операции с бд проводем в фоноыом потоке, то от спользования главного контекста сознательно отказываемся
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

//    2 - это добавляем в класс, который обслуживает кор дату
    func first<T: NamedDBEntity>(
        entity: T.Type,
        byRemoteId remoteId: String?,
        context: NSManagedObjectContext) -> T? {
            guard let remoteId = remoteId else {
                return nil
            }

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T._entityName)
            fetchRequest.predicate = NSPredicate(format: "remoteId = %@", remoteId)
            fetchRequest.fetchLimit = 1
            do {
                return try context.fetch(fetchRequest).first as? T
            } catch {
                print(error)
                return nil
            }
        }


    func list<T: NamedDBEntity>(
        entity: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        context: NSManagedObjectContext
    ) -> [T] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T._entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        fetchRequest.sortDescriptors = sortDescriptors

        return (try? context.fetch(fetchRequest) as? [T]) ?? []
    }
}


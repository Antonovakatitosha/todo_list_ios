//
//  DataManager.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/17/25.
//

import Foundation
import CoreData

class DataManager: NSObject, ObservableObject {

    let container = NSPersistentContainer(name: "ToDo")

    override init() {
        super.init()
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

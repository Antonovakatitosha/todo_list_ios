//
//  Task+CoreDataClass.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/17/25.
//
//

import Foundation
import CoreData

@objc(TaskDBModel)
public class TaskDBModel: NSManagedObject {

    convenience init(from model: TaskAPIModel, context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = UUID()
        self.title = model.todo
        self.createdAt = Date()
        self.isCompleted = model.completed
    }

    convenience init(title: String, note: String, context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = UUID()
        self.title = title
        self.note = note
        self.createdAt = Date()
        self.isCompleted = false
    }
}

extension TaskDBModel {

    func updateTask(title: String, note: String) {
        self.title = title
        self.note = note
    }

    func checkTask() {
        self.isCompleted.toggle()
    }
}

// MARK: - Helpers
extension TaskDBModel {

    var asUIModel: TaskUIModel { TaskUIModel(self) }
}

// MARK: - NamedDBEntity
extension TaskDBModel: NamedDBEntity {

    public static var _entityName: String { "Task" }
}

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

}

extension TaskDBModel {

    static func createTask(
        in context: NSManagedObjectContext,
        title: String,
        note: String
    ) throws -> TaskDBModel {
        let newTask = TaskDBModel(context: context)

        newTask.id = UUID()
        newTask.title = title
        newTask.note = note
        newTask.createdAt = Date()
        newTask.isCompleted = false

        try context.save()
        return newTask
    }

    func updateTask(
        in context: NSManagedObjectContext,
        title: String,
        note: String
    ) throws  -> TaskDBModel {

        self.title = title
        self.note = note

        try context.save()
        return self
    }
}

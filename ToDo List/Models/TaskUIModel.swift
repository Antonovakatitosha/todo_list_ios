//
//  TaskUIModel.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/20/25.
//

import Foundation

struct TaskUIModel: Identifiable {
    let id: UUID
    var title: String
    var note: String?
    let createdAt: Date?
    var isCompleted: Bool

    init(_ dbModel: TaskDBModel) {
        self.id = dbModel.id!
        self.title = dbModel.title ?? ""
        self.note = dbModel.note
        self.createdAt = dbModel.createdAt
        self.isCompleted = dbModel.isCompleted
    }
}

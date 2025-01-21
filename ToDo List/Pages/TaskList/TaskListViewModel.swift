//
//  TackListViewModel.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/20/25.
//

import SwiftUI

@Observable
final class TaskListViewModel {

    var tasks: [TaskUIModel] = []
    var searchText: String = ""

    func fetchTasks() {
        DataManager.shared.performBackgroundTask { backgroundContext in

            let predicate: NSPredicate? = self.searchText.isEmpty ? nil : NSPredicate(format: "title CONTAINS[cd] %@", self.searchText)

            let taskDBList = DataManager.shared.list(
                entity: TaskDBModel.self,
                predicate: predicate,
                context: backgroundContext
            )

            self.tasks = taskDBList.map(TaskUIModel.init)
        }
    }
}

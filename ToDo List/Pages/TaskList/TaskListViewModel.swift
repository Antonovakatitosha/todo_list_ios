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

    var showErrorAlert = false
    var errorDetail = ""

    func fetchTasks() {
        DBManager.shared.performBackgroundTask { backgroundContext in

            let predicate: NSPredicate? = self.searchText.isEmpty
                ? nil
                : NSPredicate(format: "title CONTAINS[cd] %@", self.searchText)

            do {
                try self.tasks = DBManager.shared
                    .list(
                        entity: TaskDBModel.self,
                        predicate: predicate,
                        context: backgroundContext
                    )
                    .map(TaskUIModel.init)
            } catch {
                
            }
        }
    }

    func onAppear() {
        if LaunchService.isFirstLaunch() {
            TaskService.initialLoad (
                onSuccess: { self.fetchTasks() },
                onError: { error in
                    self.showErrorAlert = true
                    self.errorDetail = error.localizedDescription
                })
        } else { fetchTasks() }
    }
}

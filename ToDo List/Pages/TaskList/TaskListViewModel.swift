//
//  TackListViewModel.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/20/25.
//

import SwiftUI

@Observable
final class TaskListViewModel {

    var tasks: [TaskDBModel] = []

    func onAppear() {
        fetchTasks { [weak self] result in
            switch result {
            case .success:
                print("все хорошо")
                self?.loadTasksFromStore()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func fetchTasks(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            // получили таски с сервера
            let tasks = [
                TaskAPIModel(todo: "title 1", isCompleted: false),
                TaskAPIModel(todo: "title 2", isCompleted: true),
                TaskAPIModel(todo: "title 3", isCompleted: false),
            ]

            //сохранили в фоне
            DataManager.shared.performBackgroundTask { backgroundContext in
                for task in tasks {
                    _ = TaskDBModel(from: task, context: backgroundContext)
                }

                do {
                    try backgroundContext.save()

                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    print("error when save data", error)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

            }
        }
    }


    private func loadTasksFromStore() {
        /// 1. открываем фоновый контекст БД через performBackgroundTask
        /// 2. используем метод DataManager-а, чтобы запросить список
        /// 3. маппим получившийся массив DB-моделей в массив [Task]
    }
}

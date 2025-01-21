//
//  TaskService.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/21/25.
//

class TaskService {

    static let tasksURLString = "https://dummyjson.com/todos"

    static func initialLoad(
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {

        NetworkManager.shared.get(
            urlString: tasksURLString,
            responseType: TodosResponse.self
        ) { result in
            switch result {

            case .success(let response):
                TaskService.saveTasks(
                    response.todos,
                    onSuccess: onSuccess,
                    onError: onError
                )

            case .failure(let error): onError(error)
            }
        }
    }

    static func saveTasks(
        _ tasks: [TaskAPIModel],
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {

        DataManager.shared.performBackgroundTask { backgroundContext in
            _ = tasks.map{ TaskDBModel(from: $0, context: backgroundContext) }

            do { try backgroundContext.save() }
            catch { onError(error) }

            onSuccess()
        }
    }

    static func generateShareContent(task: TaskUIModel) -> String {
        let status = task.isCompleted ? "✅ Выполнена" : "❌ Не выполнена"

        let text = """
        Задача: \(task.title)
        Комментарий: \(task.note ?? "Нет")
        Статус: \(status)
        """

        return text
    }
}

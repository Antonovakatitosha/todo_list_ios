//
//  TaskList.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/15/25.
//

import SwiftUI

struct TaskListPage: View {
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<TaskDBModel>

//    let tasks: [Task] = [
//        Task(id: 0, title: "Почитать книгу", description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку! Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", isCompleted: true, createdAt: Date.now),
//        Task(id: 1, title: "Уборка в квартире", isCompleted: false),
//        Task(id: 2, title: "Работа над проектом", isCompleted: false),
//        Task(id: 3, title: "Вечерний отдых", isCompleted: false),
//        Task(id: 4, title: "Зарядка утром", isCompleted: false),
//    ]

    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                List(tasks) { task in
                    TaskRow(task: task)
                        .listSectionSeparator(.hidden, edges: .top)
                        .listSectionSeparator(.hidden, edges: .bottom)
                }
                .listStyle(.inset)

                BottomBar()
            }
            .navigationTitle("Задачи")
            .searchable(text: $searchText, prompt: "Поиск") {

            }
        }
    }

    var searchResults: [TaskDBModel] {
        if searchText.isEmpty {
            return Array(tasks)
        } else {
            return tasks.filter { $0.title?.contains(searchText) ?? false }
        }
    }
}


#Preview {
    TaskListPage()
}

//
//  TaskList.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/15/25.
//

import SwiftUI

struct TaskListPage: View {

    @State private var vm = TaskListViewModel()
    @State private var searchText = ""

    @State private var showErrorAlert = false
    @State private var errorDetail = ""

    var body: some View {
        NavigationStack {
            ZStack {
                List(vm.tasks) { task in
                    TaskRow(task: task, onEdit: vm.fetchTasks)
                        .listSectionSeparator(.hidden, edges: .top)
                        .listSectionSeparator(.hidden, edges: .bottom)
                }
                .listStyle(.inset)

                BottomBar(taskCount: vm.tasks.count, onEdit: vm.fetchTasks)
            }
            .navigationTitle("Задачи")
            .searchable(text: $searchText, prompt: "Поиск")
            .onChange(of: searchText) {
                vm.searchText = $1
                vm.fetchTasks()
            }
        }
        .onAppear(perform: onAppear)
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Ошибка получения задач"),
                message: Text(errorDetail)
            )
        }
    }

    func onAppear() {
        if LaunchService.isFirstLaunch() {
            TaskService.initialLoad (
                onSuccess: {
                    vm.fetchTasks()
                }, onError: { error in
                    showErrorAlert = true
                    errorDetail = error.localizedDescription
                })
        } else {
            vm.fetchTasks()
        }
    }
}


#Preview {
    TaskListPage()
}

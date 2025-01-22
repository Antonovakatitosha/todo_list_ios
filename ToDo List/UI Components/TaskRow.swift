//
//  TaskRow.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/15/25.
//

import SwiftUI

struct TaskRow: View {
    
    let task: TaskUIModel
    var onEdit: () -> Void

    @State private var showErrorAlert = false
    @State private var errorDetail = ""

    var body: some View {
        Button(action: toggleTask) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: task.isCompleted ? "checkmark.circle" : "circle" )
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(task.isCompleted ? .yellow : .gray)

                TaskPreview(task: task)
            }
            .contextMenu {
                NavigationLink(destination: TaskEditorPage(task: task, onEdit: onEdit))  {
                    HStack {
                        Image("edit")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                        Text("Редактировать")
                            .font(.system(size: 17))
                    }
                }
                ShareLink(item: TaskService.generateShareContent(task: task)) {
                    HStack {
                        Image("export")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                        Text("Поделиться")
                            .font(.system(size: 17))
                    }
                }
                Button(role: .destructive, action: deleteTask) {
                    HStack {
                        Image("trash")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.red)
                            .frame(width: 16, height: 16)
                        Text("Удалить")
                            .font(.system(size: 17))
                    }
                }
            } preview: {
                TaskPreview(task: task)
                    .padding(20)
                    .containerRelativeFrame(.horizontal)
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Ошибка изменения задачи"),
                message: Text(errorDetail)
            )
        }
    }

    private func deleteTask() {

        DBManager.shared.performBackgroundTask { backgroundContext in

            do {
                let isDeleted = try !DBManager.shared.delete(
                    entity: TaskDBModel.self,
                    byID: task.id,
                    context: backgroundContext
                )
                guard isDeleted else {
                    handleError(with: "Ошибка удаления задачи")
                    return
                }

                try backgroundContext.save()
                onEdit()
            } catch { handleError(with: error.localizedDescription) }
        }

    }

    private func toggleTask() {
        DBManager.shared.performBackgroundTask { backgroundContext in
            do {
                let dbTask = try DBManager.shared.first(
                    entity: TaskDBModel.self,
                    byId: task.id,
                    context: backgroundContext
                )
                dbTask?.checkTask()

                try backgroundContext.save()
                onEdit()
            } catch { handleError(with: error.localizedDescription) }
        }
    }

    private func handleError(with errorDescription: String) {
        DispatchQueue.main.async {
            showErrorAlert = true
            errorDetail = errorDescription
        }
    }
}


#Preview {

}

struct TaskPreview: View {
    let task: TaskUIModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(task.title)
                .font(.system(size: 16))
                .strikethrough(task.isCompleted, color: .gray)
                .foregroundStyle(task.isCompleted ? .gray : .white)

            if let note = task.note {
                Text(note)
                    .font(.system(size: 12))
                    .foregroundStyle(task.isCompleted ? .gray : .white)
                    .lineSpacing(1)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }

            FormatedDate(date: Date())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

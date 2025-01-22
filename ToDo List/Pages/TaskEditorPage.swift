//
//  TaskEditor.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/16/25.
//

import SwiftUI

struct TaskEditorPage: View {
    @Environment(\.dismiss) private var dismiss

    let task: TaskUIModel?
    var onEdit: () -> Void

    @State private var title: String
    @State private var note: String
    @State private var createdAt: Date
    @State private var showErrorAlert = false
    @State private var errorDetail = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    TextField("Введите заголовок", text: $title)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 34))

                    FormatedDate(date: createdAt)
                        .padding(.top, 8)

                    TextEditor(text: $note)
                        .font(.system(size: 16))
                        .lineSpacing(6)
                        .frame(minHeight: 200)
                        .padding(.top, 16)
                        .padding(.horizontal, -4)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: saveOrCreate) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Назад")
                            .foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
        .alert("Ошибка сохранения", isPresented: $showErrorAlert, actions: {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }, message: { Text(errorDetail)})
    }

    init(task: TaskUIModel?, onEdit:  @escaping () -> Void) {
        self.task = task
        self.onEdit = onEdit
        _title = State(initialValue: task?.title ?? "")
        _note = State(initialValue: task?.note ?? "")
        _createdAt = State(initialValue: task?.createdAt ?? Date())
    }

    private func saveOrCreate() {

        guard !title.isEmpty else {
            handleError(with: "Невозможно сохранить задачу без названия")
            return
        }

        DBManager.shared.performBackgroundTask { backgroundContext in

            do {
                if let task = task {
                    let dbTask = try DBManager.shared.first(
                        entity: TaskDBModel.self,
                        byId: task.id,
                        context: backgroundContext
                    )
                    dbTask?.updateTask(title: title, note: note)

                } else {
                    _ = TaskDBModel(title: title, note: note, context: backgroundContext)
                }

                try backgroundContext.save()
                onEdit()
                
                DispatchQueue.main.async {
                    dismiss()
                }
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
    TaskEditorPage(
        task: .init(
            .init(
                title: "Test title",
                note: "Some note",
                context: DBManager.shared.viewContext
            )
        ),
        onEdit: {}
    )
}

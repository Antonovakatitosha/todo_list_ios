//
//  TaskEditor.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/16/25.
//

import SwiftUI

struct TaskEditorPage: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var moc

    @State private var title: String
    @State private var note: String
    @State private var createdAt: Date

    let task: TaskDBModel?

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
                    Button(action: {
                        guard !title.isEmpty else {
                            showErrorAlert = true
                            errorDetail = "Невозможно сохранить задачу без названия"
                            return
                        }

                        do {
                            if let task = task {
                               _ = try task.updateTask(in: moc, title: title, note: note)

                            } else {
                                _ = try TaskDBModel.createTask(in: moc, title: title, note: note)
                            }
                            dismiss()
                        } catch {
                            showErrorAlert = true
                            errorDetail = error.localizedDescription
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Назад")
                            .foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
        .alert("Ошибка сохранения",
               isPresented: $showErrorAlert,
               actions: {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }, message: { Text(errorDetail)})
    }

    init(task: TaskDBModel?) {
        self.task = task
        _title = State(initialValue: task?.title ?? "")
        _note = State(initialValue: task?.note ?? "")
        _createdAt = State(initialValue: task?.createdAt ?? Date())
    }

}

#Preview {
//    let task = Task(id: 0, title: "Почитать книгу", note: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку! Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", isCompleted: false)

//    TaskEditor(task: task, onSave: {_ in })
}

//
//  AddTaskView.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskListViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    @State private var showingExitAlert = false
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var hasUnsavedChanges: Bool {
        !title.isEmpty || !description.isEmpty || hasDueDate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название задачи", text: $title)
                    TextField("Описание (необязательно)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Детали") {
                    Picker("Приоритет", selection: $priority) {
                        Text("Низкий").tag(Priority.low)
                        Text("Средний").tag(Priority.medium)
                        Text("Высокий").tag(Priority.high)
                    }
                    
                    Toggle("Установить дедлайн", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Дата", selection: $dueDate, displayedComponents: [.date])
                    }
                }
                
            }
            .navigationTitle("Новая задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        handleCancel()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveTask()
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Отменить задание?", isPresented: $showingExitAlert) {
                Button("Продолжить", role: .cancel) { }
                Button("Отменить", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Введённые данные будут потеряны")
            }
        }
    }
    
    private func handleCancel() {
        if hasUnsavedChanges {
            showingExitAlert = true
        } else {
            dismiss()
        }
    }
    
    private func saveTask() {
        viewModel.addTask(title: title,
                          description: description.isEmpty ? nil : description,
                          priority: priority,
                          dueDate: hasDueDate ? dueDate : nil
        )
        dismiss()
    }
}



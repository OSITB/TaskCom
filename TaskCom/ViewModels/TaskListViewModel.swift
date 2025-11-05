//
//  TaskListViewModel.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadTask()
    }
    
    func loadTask() {
        tasks = coreDataManager.fetchTasks()
    }
    
    // СОЗДАНИЕ
    func addTask(title: String, description: String?, priority: Priority, dueDate: Date?) {
        let newTask = Task(
            id: UUID(),
            title: title,
            taskDescription: description,
            priority: priority,
            isCompleted: false,
            createdAt: Date(),
            dueDate: dueDate,
            completedAt: nil)
        
        coreDataManager.create(newTask)
        tasks.append(newTask)
    }
    
    // ОБНОВЛЕНИЕ (отметить выполненной)
    func toggleCompletion(for task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id}) else { return }
        
        var updatedTask = tasks[index]
        updatedTask.isCompleted.toggle()
        updatedTask.completedAt = updatedTask.isCompleted ? Date() : nil
        
        coreDataManager.update(updatedTask)
        tasks[index] = updatedTask
    }
    
    // УДАЛЕНИЕ
    func deleteTask(_ task: Task) {
        coreDataManager.delete(task)
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks.remove(at: index)
        }
    }
    
}

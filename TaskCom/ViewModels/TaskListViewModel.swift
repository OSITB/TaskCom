//
//  TaskListViewModel.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import Foundation
import Combine

enum TaskFilter: String, CaseIterable {
    case all = "Все"
    case active = "Активные"
    case completed = "Выполненные"
}

enum SortOption {
    case createdDate    // По дате создания
    case dueDate    // По дедлайну
    case priority   // По приоритету
    case title  // По алфавиту
}

class TaskListViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var selectedFilter: TaskFilter = .all
    @Published var sortOption: SortOption = .createdDate
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadTask()
    }
    
    // Computed property для фильтрации
    var filteredTasks: [Task] {
        let filtered: [Task]
        
        switch selectedFilter {
        case .all:
            filtered = tasks
        case .active:
            filtered = tasks.filter { !$0.isCompleted }
        case .completed:
            filtered = tasks.filter { $0.isCompleted }
        }
        
        return sortTasks(filtered)
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
    
    private func sortTasks(_ tasks: [Task]) -> [Task] {
        switch sortOption {
        case .createdDate:
            return tasks.sorted { $0.createdAt > $1.createdAt}
        case .dueDate:
            return tasks.sorted { task1, task2 in
                switch (task1.dueDate, task2.dueDate) {
                case (nil, nil):
                    return task1.createdAt < task2.createdAt
                case (nil, _):
                    return false
                case (_, nil):
                    return true
                case (let date1?, let date2?):
                    return date1 < date2
                }}
        case .priority:
            return tasks.sorted { $0.priority.rawValue > $1.priority.rawValue}
        case .title:
            return tasks.sorted { $0.title < $1.title}
        }
    }
}

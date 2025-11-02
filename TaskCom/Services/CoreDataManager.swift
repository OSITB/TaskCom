//
//  CoreDataManager.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // Контейнер CoreData
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "TaskCom")
        print("🏗️ CoreDataManager создан!")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Ошибка загрузки CoreData: \(error)")
            }
        }
        
    }
    
    func fetchTask() -> [Task] {
            // 1. Создаём запрос к базе данных
            let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        // 2. Выполняем запрос
        do {
            let taskEntities = try container.viewContext.fetch(request)
            
            // 3. Конвертируем TaskEntity -> Task
            return taskEntities.map { entity in
                convertToTask(from: entity)}
        } catch {
            print("Ошибка загрузки: \(error)")
            return []
        }
        
        }
    
    func create(_ task: Task) {
        // 1. Создаём новый объект в контексте
        let entity = TaskEntity(context: container.viewContext)
        
        // 2. Копируем данные
        entity.id = task.id
        entity.title = task.title
        entity.taskDescription = task.taskDescription
        entity.priorityRaw = Int16(task.priority.rawValue)
        entity.isCompleted = task.isCompleted
        entity.createdAt = task.createdAt
        entity.dueDate = task.dueDate
        entity.completedAt = task.completedAt
        
        // 3. Сохраняем контекст
        saveContext()
    }
    
    func update(_ task: Task) {
        // 1. Создаём запрос поиска по id
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let results = try container.viewContext.fetch(request)
            
            // 2. Берём первый результат (id уникален)
            guard let entity = results.first else {
                print("⚠️ Задача с id \(task.id) не найдена")
                return
            }
            
            // 3. Обновляем поля
            entity.title = task.title
            entity.taskDescription = task.taskDescription
            entity.priorityRaw = Int16(task.priority.rawValue)
            entity.isCompleted = task.isCompleted
            entity.dueDate = task.dueDate
            entity.completedAt = task.completedAt
            
            // 4. Сохраняем
            saveContext()
        } catch {
            print("Ошибка поиска: \(error)")
        }
    }
    
    private func convertToTask(from entity: TaskEntity) -> Task {
        return Task(id: entity.id ?? UUID(),
                    title: entity.title ?? "Без названия",
                    taskDescription: entity.taskDescription ?? "Нет описания",
                    priority: Priority(rawValue: Int(entity.priorityRaw)) ?? .medium,
                    isCompleted: entity.isCompleted,
                    createdAt: entity.createdAt ?? Date(),
                    dueDate: entity.dueDate ?? Date(),
                    completedAt: entity.completedAt ?? Date())
    }
    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}



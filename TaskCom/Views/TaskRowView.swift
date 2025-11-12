//
//  TaskRowView.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    
    var body: some View {
        
        HStack(spacing: 12) {
            // Левая часть: название + описание
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                
                if let description = task.taskDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        Spacer()
        
        // Правая часть: приоритет + дедлайн + чекбокс
        HStack(spacing: 12) {
            // Индикатор приоритета
            Circle()
                .fill(priorityColor(task.priority))
                .frame(width: 12, height: 12)
            
            // Дедлайн
            if let dueDate = task.dueDate {
                Text(formatData(dueDate))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Чекбокс
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "cirle")
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
        }
        .padding(.vertical, 8)
        .opacity(task.isCompleted ? 0.6 : 1.0)
    }
    
    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private func formatData(_ date: Date) -> String {
        // Упрощенное форматирование
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Сегодня"
        } else if calendar.isDateInTomorrow(date) {
            return "Завтра"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            return formatter.string(from: date)
        }
    }
}


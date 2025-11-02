//
//  Task.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import Foundation

struct Task {
    let id: UUID
    var title: String
    var taskDescription: String?
    var priority: Priority
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?
    var completedAt: Date?
}

enum Priority: Int, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
}

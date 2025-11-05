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
}

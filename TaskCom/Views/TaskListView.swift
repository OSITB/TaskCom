//
//  ContentView.swift
//  TaskCom
//
//  Created by Илья Быков on 25.10.2025.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var showingAddTask = false
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.tasks.isEmpty {
                    EmptyStateView()
                } else {
                    taskList
                }
            }
        }
        .navigationTitle("Задачи")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddTask = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
    }
    private var taskList: some View {
        List {
            // Фильтр
            Picker("Фильтр", selection: $viewModel.selectedFilter) {
                ForEach(TaskFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)}
            }
        }
        .pickerStyle(.segmented)
        .listRowSeparator(.hidden)
        
            // Список задач
        return ForEach(viewModel.filteredTasks) { task in
            TaskRowView(task: task) {
                viewModel.toggleCompletion(for: task)
            }
        }
        .onDelete(perform: deleteTask)
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = viewModel.filteredTasks[index]
            viewModel.deleteTask(task)}
    }
}


#Preview {
    TaskListView()
}

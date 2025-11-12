//
//  EmptyStateView.swift
//  TaskCom
//
//  Created by Илья Быков on 12.11.2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundStyle(.gray)
            
            Text("Нет задач")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Создайте новую задачу")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    EmptyStateView()
}

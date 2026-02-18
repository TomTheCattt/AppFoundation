//
//  TaskCoordinator.swift
//  AppFoundation
//

import Foundation

/// Priority for coordinated tasks. Use when scheduling work.
enum TaskPriority {
    case low, medium, high
}

actor TaskCoordinator {
    private var tasks: [String: Task<Void, Error>] = [:]

    func execute(id: String, priority: TaskPriority = .medium, operation: @escaping @Sendable () async throws -> Void) {
        cancel(id: id)
        tasks[id] = Task {
            defer { 
                Task { await removeTask(id: id) }
            }
            try await operation()
        }
    }

    private func removeTask(id: String) {
        tasks.removeValue(forKey: id)
    }

    func cancel(id: String) {
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }

    func cancelAll() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}

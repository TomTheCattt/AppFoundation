//
//  TaskCoordinator.swift
//  BaseIOSApp
//

import Foundation

/// Priority for coordinated tasks. Use when scheduling work.
enum TaskPriority {
    case low, medium, high
}

final class TaskCoordinator {
    private var tasks: [String: Task<Void, Error>] = [:]
    private let queue = DispatchQueue(label: "TaskCoordinator")

    func execute(id: String, priority: TaskPriority = .medium, operation: @escaping () async throws -> Void) {
        cancel(id: id)
        let task = Task {
            try await operation()
            queue.async { self.tasks.removeValue(forKey: id) }
        }
        queue.async { self.tasks[id] = task }
    }

    func cancel(id: String) {
        queue.async {
            self.tasks[id]?.cancel()
            self.tasks.removeValue(forKey: id)
        }
    }

    func cancelAll() {
        queue.async {
            self.tasks.values.forEach { $0.cancel() }
            self.tasks.removeAll()
        }
    }
}

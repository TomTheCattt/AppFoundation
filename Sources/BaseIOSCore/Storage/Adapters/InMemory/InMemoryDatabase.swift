//
//  InMemoryDatabase.swift
//  BaseIOSApp
//
//  Testing / preview database. No persistence.
//

import Foundation

// Marked @unchecked Sendable because internal state is protected by a serial dispatch queue.
final class InMemoryDatabase: LocalDatabaseProtocol, @unchecked Sendable {
    private var storage: [String: [Any]] = [:]
    private let queue = DispatchQueue(label: "InMemoryDB")

    func create<T: Storable>(_ object: T) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async {
                let key = String(describing: T.self)
                self.storage[key, default: []].append(object)
                cont.resume()
            }
        }
    }

    func read<T: Storable>(type: T.Type, primaryKey: Any) async throws -> T? {
        try await withCheckedThrowingContinuation { cont in
            queue.async {
                let key = String(describing: T.self)
                let list = self.storage[key] as? [T] ?? []
                let pkKey = T.primaryKey ?? "id"
                let pkStr = "\(primaryKey)"
                let found = list.first { (obj) in
                    (obj as? AnyObject).flatMap { $0.value(forKey: pkKey).map { "\($0)" == pkStr } } ?? false
                }
                cont.resume(returning: found)
            }
        }
    }

    func update<T: Storable>(_ object: T) async throws {
        try await create(object)
    }

    func delete<T: Storable>(_ object: T) async throws {
        queue.async {
            let key = String(describing: T.self)
            self.storage[key] = (self.storage[key])?.filter { ($0 as? AnyObject) !== (object as? AnyObject) } ?? []
        }
    }

    func createAll<T: Storable>(_ objects: [T]) async throws {
        for obj in objects { try await create(obj) }
    }

    func deleteAll<T: Storable>(type: T.Type) async throws {
        queue.async {
            self.storage[String(describing: T.self)] = []
        }
    }

    func fetch<T: Storable>(
        type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) async throws -> [T] {
        try await withCheckedThrowingContinuation { cont in
            queue.async {
                let key = String(describing: T.self)
                var list = (self.storage[key] as? [T]) ?? []
                if let p = predicate {
                    list = list.filter { p.evaluate(with: $0) }
                }
                cont.resume(returning: list)
            }
        }
    }

    func performTransaction(_ block: @escaping () -> Void) async throws {
        block()
    }
}

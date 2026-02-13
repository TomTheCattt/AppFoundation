//
//  UserDefaultsPendingSyncQueue.swift
//  BaseIOSApp
//
//  Persists pending sync items in UserDefaults. For production consider Core Data or file-based queue.
//

import Foundation

private let storageKey = "baseiosapp.pending_sync_queue"

final class UserDefaultsPendingSyncQueue: PendingSyncQueueProtocol {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSLock()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func enqueue(_ item: PendingSyncItem) throws {
        lock.lock()
        defer { lock.unlock() }
        var list = loadLocked()
        list.append(item)
        try saveLocked(list)
    }

    func dequeue(limit: Int = 50) throws -> [PendingSyncItem] {
        lock.lock()
        defer { lock.unlock() }
        var list = loadLocked()
        let taken = Array(list.prefix(limit))
        list.removeFirst(min(limit, list.count))
        try saveLocked(list)
        return taken
    }

    func remove(ids: [String]) throws {
        lock.lock()
        defer { lock.unlock() }
        var list = loadLocked()
        list.removeAll { ids.contains($0.id) }
        try saveLocked(list)
    }

    func count() throws -> Int {
        lock.lock()
        defer { lock.unlock() }
        return loadLocked().count
    }

    func removeAll() throws {
        lock.lock()
        defer { lock.unlock() }
        try saveLocked([])
    }

    private func loadLocked() -> [PendingSyncItem] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        let wrapper = try? decoder.decode([CodablePendingSyncItem].self, from: data)
        return wrapper?.map { $0.toItem() } ?? []
    }

    private func saveLocked(_ list: [PendingSyncItem]) throws {
        let wrapper = list.map { CodablePendingSyncItem(from: $0) }
        let data = try encoder.encode(wrapper)
        defaults.set(data, forKey: storageKey)
    }
}

private struct CodablePendingSyncItem: Codable {
    let id: String
    let kind: String
    let entityType: String
    let payload: Data
    let createdAt: Date

    init(from item: PendingSyncItem) {
        id = item.id
        kind = item.kind.rawValue
        entityType = item.entityType
        payload = item.payload
        createdAt = item.createdAt
    }

    func toItem() -> PendingSyncItem {
        PendingSyncItem(
            id: id,
            kind: PendingSyncItem.Kind(rawValue: kind) ?? .update,
            entityType: entityType,
            payload: payload,
            createdAt: createdAt
        )
    }
}

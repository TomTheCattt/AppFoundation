//
//  PendingSyncItem.swift
//  AppFoundation
//

import Foundation

/// A single pending operation to be synced when back online.
struct PendingSyncItem: Codable, Equatable {
    let id: String
    let kind: Kind
    let entityType: String
    let payload: Data
    let createdAt: Date

    enum Kind: String, Codable {
        case create
        case update
        case delete
    }

    init(id: String = UUID().uuidString, kind: Kind, entityType: String, payload: Data, createdAt: Date = Date()) {
        self.id = id
        self.kind = kind
        self.entityType = entityType
        self.payload = payload
        self.createdAt = createdAt
    }
}

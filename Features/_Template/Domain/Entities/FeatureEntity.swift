//
//  FeatureEntity.swift
//  BaseIOSApp
//
//  Business model for Feature. Pure Swift, no framework dependencies.
//

import Foundation

struct FeatureEntity: Identifiable, Equatable, Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: URL?
    let createdAt: Date
    let updatedAt: Date
    let status: FeatureStatus
    let priority: Int
    let tags: [String]

    var isActive: Bool { status == .active }
    var displayTitle: String { "[\(priority)] \(title)" }

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        imageURL: URL? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        status: FeatureStatus = .active,
        priority: Int = 0,
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
        self.priority = priority
        self.tags = tags
    }

    // MARK: - Business Rules

    func canBeDeleted() -> Bool { status != .archived }
    func canBeEdited() -> Bool { status == .active || status == .draft }

    func validate() throws {
        guard !title.isEmpty else { throw FeatureError.validation(.emptyTitle) }
        guard title.count <= 100 else { throw FeatureError.validation(.titleTooLong) }
        guard priority >= 0 && priority <= 10 else { throw FeatureError.validation(.invalidPriority) }
    }
}

enum FeatureStatus: String, Codable {
    case draft, active, inactive, archived
}

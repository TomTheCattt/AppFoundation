//
//  FeatureRecord.swift
//  BaseIOSApp
//
//  Storable type for local persistence. Maps to FeatureEntity in Data layer.
//

import Foundation

/// Class-based record for LocalDatabaseProtocol (Storable requires reference type for KVC).
final class FeatureRecord: NSObject, Storable {
    static var primaryKey: String? { "id" }

    @objc let id: String
    let title: String
    let featureDescription: String
    let createdAt: Date
    let updatedAt: Date
    let statusRaw: String
    let priority: Int
    let tags: [String]

    init(
        id: String,
        title: String,
        featureDescription: String,
        createdAt: Date,
        updatedAt: Date,
        statusRaw: String,
        priority: Int,
        tags: [String]
    ) {
        self.id = id
        self.title = title
        self.featureDescription = featureDescription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.statusRaw = statusRaw
        self.priority = priority
        self.tags = tags
    }

    static func from(_ entity: FeatureEntity) -> FeatureRecord {
        FeatureRecord(
            id: entity.id,
            title: entity.title,
            featureDescription: entity.description,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
            statusRaw: entity.status.rawValue,
            priority: entity.priority,
            tags: entity.tags
        )
    }

    func toEntity() -> FeatureEntity? {
        guard let status = FeatureStatus(rawValue: statusRaw) else { return nil }
        return FeatureEntity(
            id: id,
            title: title,
            description: featureDescription,
            createdAt: createdAt,
            updatedAt: updatedAt,
            status: status,
            priority: priority,
            tags: tags
        )
    }
}

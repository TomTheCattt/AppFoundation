//
//  FeatureDTOMapper.swift
//  BaseIOSApp
//

import Foundation

enum FeatureDTOMapper {
    static func toDomain(_ dto: FeatureDTO) throws -> FeatureEntity {
        guard let createdAt = parseDate(dto.createdAt),
              let updatedAt = parseDate(dto.updatedAt),
              let status = FeatureStatus(rawValue: dto.status) else {
            throw MappingError.invalidData
        }
        return FeatureEntity(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            status: status,
            priority: dto.priority,
            tags: dto.tags
        )
    }

    static func toDomain(_ dtos: [FeatureDTO]) throws -> [FeatureEntity] {
        try dtos.map { try toDomain($0) }
    }

    static func toRequestDTO(_ entity: FeatureEntity) -> FeatureRequestDTO {
        FeatureRequestDTO(
            title: entity.title,
            description: entity.description,
            status: entity.status.rawValue,
            priority: entity.priority,
            tags: entity.tags
        )
    }

    private static func parseDate(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: string) { return date }
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string)
    }
}

enum MappingError: Error {
    case invalidData
}

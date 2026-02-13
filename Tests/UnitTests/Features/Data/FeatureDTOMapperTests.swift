//
//  FeatureDTOMapperTests.swift
//  AppFoundationTests
//

import XCTest
@testable import AppFoundation

final class FeatureDTOMapperTests: XCTestCase {

    private let iso8601 = ISO8601DateFormatter()

    func test_toDomain_validDTO_returnsEntity() throws {
        let dateString = iso8601.string(from: Date())
        let dto = FeatureDTO(
            id: "id-1",
            title: "Title",
            description: "Desc",
            createdAt: dateString,
            updatedAt: dateString,
            status: "active",
            priority: 5,
            tags: ["a", "b"]
        )
        let entity = try FeatureDTOMapper.toDomain(dto)
        XCTAssertEqual(entity.id, "id-1")
        XCTAssertEqual(entity.title, "Title")
        XCTAssertEqual(entity.description, "Desc")
        XCTAssertEqual(entity.status, .active)
        XCTAssertEqual(entity.priority, 5)
        XCTAssertEqual(entity.tags, ["a", "b"])
    }

    func test_toDomain_invalidStatus_throws() {
        let dateString = iso8601.string(from: Date())
        let dto = FeatureDTO(
            id: "id-1",
            title: "T",
            description: "D",
            createdAt: dateString,
            updatedAt: dateString,
            status: "invalid_status",
            priority: 0,
            tags: []
        )
        XCTAssertThrowsError(try FeatureDTOMapper.toDomain(dto)) { error in
            XCTAssertTrue(error is MappingError)
        }
    }

    func test_toDomain_invalidDate_throws() {
        let dto = FeatureDTO(
            id: "id-1",
            title: "T",
            description: "D",
            createdAt: "not-a-date",
            updatedAt: "2025-01-01T00:00:00Z",
            status: "active",
            priority: 0,
            tags: []
        )
        XCTAssertThrowsError(try FeatureDTOMapper.toDomain(dto))
    }

    func test_toDomain_array_mapsAll() throws {
        let dateString = iso8601.string(from: Date())
        let dtos = [
            FeatureDTO(id: "1", title: "A", description: "D", createdAt: dateString, updatedAt: dateString, status: "active", priority: 1, tags: []),
            FeatureDTO(id: "2", title: "B", description: "D", createdAt: dateString, updatedAt: dateString, status: "draft", priority: 2, tags: [])
        ]
        let entities = try FeatureDTOMapper.toDomain(dtos)
        XCTAssertEqual(entities.count, 2)
        XCTAssertEqual(entities[0].id, "1")
        XCTAssertEqual(entities[1].status, .draft)
    }

    func test_toRequestDTO_mapsCorrectly() {
        let entity = FeatureEntity(
            id: "id-1",
            title: "Title",
            description: "Desc",
            status: .active,
            priority: 3,
            tags: ["x"]
        )
        let dto = FeatureDTOMapper.toRequestDTO(entity)
        XCTAssertEqual(dto.title, "Title")
        XCTAssertEqual(dto.description, "Desc")
        XCTAssertEqual(dto.status, "active")
        XCTAssertEqual(dto.priority, 3)
        XCTAssertEqual(dto.tags, ["x"])
    }
}

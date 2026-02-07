//
//  FeatureDTO.swift
//  BaseIOSApp
//

import Foundation

struct FeatureResponseDTO: Codable {
    let data: [FeatureDTO]
    let meta: MetaDTO?
}

struct MetaDTO: Codable {
    let total: Int?
    let page: Int?
}

struct FeatureDTO: Codable {
    let id: String
    let title: String
    let description: String
    let createdAt: String
    let updatedAt: String
    let status: String
    let priority: Int
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case id, title, description, status, priority, tags
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct FeatureRequestDTO: Codable {
    let title: String
    let description: String
    let status: String
    let priority: Int
    let tags: [String]
}

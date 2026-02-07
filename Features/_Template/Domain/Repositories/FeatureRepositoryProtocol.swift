//
//  FeatureRepositoryProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol FeatureRepositoryProtocol {
    func fetchAll() async throws -> [FeatureEntity]
    func fetch(id: String) async throws -> FeatureEntity
    func create(_ entity: FeatureEntity) async throws -> FeatureEntity
    func update(_ entity: FeatureEntity) async throws -> FeatureEntity
    func delete(id: String) async throws
    func deleteAll() async throws
    func search(query: String) async throws -> [FeatureEntity]
}

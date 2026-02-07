//
//  FeatureRemoteDataSource.swift
//  BaseIOSApp
//

import Foundation

protocol FeatureRemoteDataSourceProtocol {
    func fetchAll() async throws -> [FeatureDTO]
    func fetch(id: String) async throws -> FeatureDTO
    func create(_ dto: FeatureRequestDTO) async throws -> FeatureDTO
    func update(id: String, dto: FeatureRequestDTO) async throws -> FeatureDTO
    func delete(id: String) async throws
    func deleteAll() async throws
    func search(query: String) async throws -> [FeatureDTO]
}

final class FeatureRemoteDataSource: FeatureRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    private let logger: Logger

    init(apiClient: APIClientProtocol, logger: Logger) {
        self.apiClient = apiClient
        self.logger = logger
    }

    func fetchAll() async throws -> [FeatureDTO] {
        let response: FeatureResponseDTO = try await apiClient.request(
            FeatureEndpoint.fetchAll.endpoint,
            responseType: FeatureResponseDTO.self
        )
        return response.data
    }

    func fetch(id: String) async throws -> FeatureDTO {
        try await apiClient.request(
            FeatureEndpoint.fetchById(id: id).endpoint,
            responseType: FeatureDTO.self
        )
    }

    func create(_ dto: FeatureRequestDTO) async throws -> FeatureDTO {
        try await apiClient.request(
            FeatureEndpoint.create(dto: dto).endpoint,
            responseType: FeatureDTO.self
        )
    }

    func update(id: String, dto: FeatureRequestDTO) async throws -> FeatureDTO {
        try await apiClient.request(
            FeatureEndpoint.update(id: id, dto: dto).endpoint,
            responseType: FeatureDTO.self
        )
    }

    func delete(id: String) async throws {
        _ = try await apiClient.request(
            FeatureEndpoint.delete(id: id).endpoint,
            responseType: EmptyResponse.self
        )
    }

    func deleteAll() async throws {
        _ = try await apiClient.request(
            FeatureEndpoint.deleteAll.endpoint,
            responseType: EmptyResponse.self
        )
    }

    func search(query: String) async throws -> [FeatureDTO] {
        let endpoint = Endpoint(
            path: FeatureEndpoint.search(query: query).path,
            method: .get,
            queryParameters: ["q": query]
        )
        let response: FeatureResponseDTO = try await apiClient.request(endpoint, responseType: FeatureResponseDTO.self)
        return response.data
    }
}

private struct EmptyResponse: Codable {}
//
//  FeatureEndpoint.swift
//  BaseIOSApp
//

import Foundation

enum FeatureEndpoint {
    case fetchAll
    case fetchById(id: String)
    case create(dto: FeatureRequestDTO)
    case update(id: String, dto: FeatureRequestDTO)
    case delete(id: String)
    case deleteAll
    case search(query: String)

    var path: String {
        switch self {
        case .fetchAll, .create, .deleteAll:
            return "/api/v1/features"
        case .fetchById(let id), .update(let id, _), .delete(let id):
            return "/api/v1/features/\(id)"
        case .search:
            return "/api/v1/features/search"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchAll, .fetchById, .search: return .get
        case .create: return .post
        case .update: return .put
        case .delete, .deleteAll: return .delete
        }
    }

    var body: Data? {
        switch self {
        case .create(let dto), .update(_, let dto):
            return try? JSONEncoder().encode(dto)
        default:
            return nil
        }
    }

    var endpoint: Endpoint {
        Endpoint(
            path: path,
            method: method,
            headers: ["Content-Type": "application/json", "Accept": "application/json"],
            body: body
        )
    }
}

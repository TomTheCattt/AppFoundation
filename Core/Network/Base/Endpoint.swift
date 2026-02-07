//
//  Endpoint.swift
//  BaseIOSApp
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryParameters: [String: Any]?
    let body: Data?
    let timeout: TimeInterval

    init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryParameters: [String: Any]? = nil,
        body: Data? = nil,
        timeout: TimeInterval = AppConstants.Network.timeout
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.timeout = timeout
    }

    static func get(_ path: String, query: [String: Any]? = nil) -> Endpoint {
        Endpoint(path: path, method: .get, queryParameters: query)
    }

    static func post(_ path: String, body: Data? = nil) -> Endpoint {
        Endpoint(path: path, method: .post, body: body)
    }

    static func post<T: Encodable>(_ path: String, body: T) throws -> Endpoint {
        Endpoint(path: path, method: .post, body: try JSONEncoder().encode(body))
    }
}

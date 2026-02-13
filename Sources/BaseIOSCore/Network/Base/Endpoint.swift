//
//  Endpoint.swift
//  BaseIOSApp
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public struct Endpoint {
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String]?
    public let queryParameters: [String: Any]?
    public let body: Data?
    public let timeout: TimeInterval

    public init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryParameters: [String: Any]? = nil,
        body: Data? = nil,
        timeout: TimeInterval = 30.0
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.timeout = timeout
    }

    public static func get(_ path: String, query: [String: Any]? = nil) -> Endpoint {
        Endpoint(path: path, method: .get, queryParameters: query)
    }

    public static func post(_ path: String, body: Data? = nil) -> Endpoint {
        Endpoint(path: path, method: .post, body: body)
    }

    public static func post<T: Encodable>(_ path: String, body: T) throws -> Endpoint {
        Endpoint(path: path, method: .post, body: try JSONEncoder().encode(body))
    }
}

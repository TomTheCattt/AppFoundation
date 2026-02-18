//
//  RequestBuilder.swift
//  AppFoundation
//

import Foundation

enum RequestBuilder {
    static func build(_ endpoint: Endpoint, baseURL: String) throws -> URLRequest {
        guard let url = buildURL(path: endpoint.path, baseURL: baseURL, query: endpoint.queryParameters) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeout
        addDefaultHeaders(to: &request)
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        request.httpBody = endpoint.body
        return request
    }

    private static func buildURL(path: String, baseURL: String, query: [String: Any]?) -> URL? {
        let base = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        let pathPart = path.hasPrefix("/") ? path : "/" + path
        guard var components = URLComponents(string: base + pathPart) else { return nil }
        if let query = query, !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        return components.url
    }

    private static func addDefaultHeaders(to request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("iOS", forHTTPHeaderField: "Platform")
    }
}

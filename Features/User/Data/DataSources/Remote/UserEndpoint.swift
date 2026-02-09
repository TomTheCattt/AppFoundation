//
//  UserEndpoint.swift
//  BaseIOSApp
//

import Foundation

enum UserEndpoint {
    case me

    /// BackendIntegrationGuide: GET /me (base URL already includes /api/v1).
    var path: String { "/me" }
    var method: HTTPMethod { .get }

    var endpoint: Endpoint {
        Endpoint(
            path: path,
            method: method,
            headers: ["Accept": "application/json"],
            body: nil
        )
    }
}

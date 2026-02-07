//
//  UserEndpoint.swift
//  BaseIOSApp
//

import Foundation

enum UserEndpoint {
    case me

    var path: String { "/api/v1/users/me" }
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

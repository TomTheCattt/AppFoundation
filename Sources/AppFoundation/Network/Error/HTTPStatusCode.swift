//
//  HTTPStatusCode.swift
//  AppFoundation
//

import Foundation

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500

    var isSuccess: Bool { (200...299).contains(rawValue) }
    var isClientError: Bool { (400...499).contains(rawValue) }
    var isServerError: Bool { (500...599).contains(rawValue) }
}

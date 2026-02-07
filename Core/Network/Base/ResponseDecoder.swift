//
//  ResponseDecoder.swift
//  BaseIOSApp
//

import Foundation

final class ResponseDecoder {
    private let jsonDecoder: JSONDecoder

    init() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(type, from: data)
        } catch {
            Logger.shared.error("Decoding failed: \(error)")
            throw NetworkError.decodingFailed(error)
        }
    }
}

//
//  APIResponseEnvelope.swift
//  BaseIOSApp
//
//  Format response thống nhất từ backend: { success, data } hoặc { success, error: { code, message } }.
//

import Foundation

/// Payload lỗi chuẩn từ server (error.code, error.message).
struct APIErrorPayload: Decodable {
    let code: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

/// Dùng cho response không có body (vd: logout). Backend trả data: null.
struct EmptyData: Decodable {
    init() {}
    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if !c.decodeNil() {
            throw DecodingError.typeMismatch(EmptyData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected null"))
        }
    }
}

/// Envelope success: { success: true, data: T }; error: { success: false, error: { code, message } }.
struct APIResponseEnvelope<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: APIErrorPayload?

    enum CodingKeys: String, CodingKey {
        case success
        case data
        case error
    }
}

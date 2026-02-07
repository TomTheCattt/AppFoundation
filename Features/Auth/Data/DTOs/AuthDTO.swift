//
//  AuthDTO.swift
//  BaseIOSApp
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case email, password
    }
}

struct LoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}

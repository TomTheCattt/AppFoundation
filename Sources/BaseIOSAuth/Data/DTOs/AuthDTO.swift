//
//  AuthDTO.swift
//  BaseIOSApp
//
//  Aligns with BackendIntegrationGuide: supports "token" or "access_token", optional "user".
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case email, password
    }
}

/// Login/Register response. Backend may return "token" or "access_token"; optional "user" object.
struct LoginResponseDTO: Decodable {
    /// Resolved from "token" or "access_token" (backend contract uses "token").
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval?
    /// Current user when returned by backend (e.g. login/register response).
    let user: UserDTO?

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let fromAccessToken = try? c.decode(String.self, forKey: .accessTokenKey)
        let fromToken = try? c.decode(String.self, forKey: .token)
        guard let tokenValue = fromAccessToken ?? fromToken else {
            throw DecodingError.keyNotFound(
                CodingKeys.accessTokenKey,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Missing both 'token' and 'access_token'")
            )
        }
        accessToken = tokenValue
        refreshToken = try? c.decode(String.self, forKey: .refreshToken)
        expiresIn = try? c.decode(TimeInterval.self, forKey: .expiresIn)
        user = try? c.decode(UserDTO.self, forKey: .user)
    }

    init(accessToken: String, refreshToken: String? = nil, expiresIn: TimeInterval? = nil, user: UserDTO? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.user = user
    }

    enum CodingKeys: String, CodingKey {
        case token
        case accessTokenKey = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case user
    }
}

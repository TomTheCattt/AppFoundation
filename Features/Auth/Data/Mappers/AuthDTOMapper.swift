//
//  AuthDTOMapper.swift
//  BaseIOSApp
//

import Foundation

enum AuthDTOMapper {
    static func toSession(_ dto: LoginResponseDTO) -> AuthSession {
        AuthSession(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            expiresIn: dto.expiresIn
        )
    }
}

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

    /// Maps optional user from login/register response to domain entity.
    static func toUser(_ dto: LoginResponseDTO) -> UserEntity? {
        guard let userDTO = dto.user else { return nil }
        return UserDTOMapper.toEntity(userDTO)
    }
}

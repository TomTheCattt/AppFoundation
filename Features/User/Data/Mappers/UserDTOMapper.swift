//
//  UserDTOMapper.swift
//  BaseIOSApp
//

import Foundation

enum UserDTOMapper {
    static func toEntity(_ dto: UserDTO) -> UserEntity {
        UserEntity(
            id: dto.id,
            email: dto.email,
            name: dto.name ?? "",
            avatarURL: dto.avatarURL
        )
    }
}

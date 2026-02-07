//
//  UserEntity.swift
//  BaseIOSApp
//

import Foundation

struct UserEntity: Identifiable, Equatable {
    let id: String
    let email: String
    let name: String
    let avatarURL: String?

    init(id: String, email: String, name: String, avatarURL: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.avatarURL = avatarURL
    }

    var displayName: String { name.isEmpty ? email : name }
}

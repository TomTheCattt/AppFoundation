//
//  UserDTO.swift
//  BaseIOSApp
//

import Foundation

struct UserDTO: Decodable {
    let id: String
    let email: String
    let name: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id, email, name
        case avatarURL = "avatar_url"
    }
}

//
//  UserRepositoryProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol UserRepositoryProtocol {
    func getCurrentUser() async throws -> UserEntity
}

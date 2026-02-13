//
//  AuthRepositoryProtocol.swift
//  AppFoundation
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthSession
    func register(email: String, password: String) async throws -> AuthSession
    func logout() async throws
}

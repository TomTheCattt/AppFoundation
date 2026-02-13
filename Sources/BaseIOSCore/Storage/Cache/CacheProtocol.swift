//
//  CacheProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol CacheProtocol {
    func set<T: Encodable>(_ value: T, forKey key: String, expiration: TimeInterval?) throws
    func get<T: Decodable>(forKey key: String) throws -> T?
    func remove(forKey key: String) throws
    func removeAll() throws
    func exists(forKey key: String) -> Bool
}

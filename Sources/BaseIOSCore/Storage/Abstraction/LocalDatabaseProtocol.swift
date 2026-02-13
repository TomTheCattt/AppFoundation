//
//  LocalDatabaseProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol Storable {
    static var primaryKey: String? { get }
}

protocol LocalDatabaseProtocol {
    func create<T: Storable>(_ object: T) async throws
    func read<T: Storable>(type: T.Type, primaryKey: Any) async throws -> T?
    func update<T: Storable>(_ object: T) async throws
    func delete<T: Storable>(_ object: T) async throws
    func createAll<T: Storable>(_ objects: [T]) async throws
    func deleteAll<T: Storable>(type: T.Type) async throws
    func fetch<T: Storable>(
        type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) async throws -> [T]
    func performTransaction(_ block: @escaping () -> Void) async throws
}

//
//  QueryProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol QueryProtocol {
    associatedtype ResultType: Storable
    func filter(_ predicate: NSPredicate) -> Self
    func sort(by keyPath: String, ascending: Bool) -> Self
    func limit(_ count: Int) -> Self
    func offset(_ count: Int) -> Self
    func fetch() async throws -> [ResultType]
    func fetchFirst() async throws -> ResultType?
    func count() async throws -> Int
}

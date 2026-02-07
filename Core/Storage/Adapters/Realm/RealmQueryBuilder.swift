//
//  RealmQueryBuilder.swift
//  BaseIOSApp
//

import Foundation
import RealmSwift

final class RealmQueryBuilder<T: Object>: QueryProtocol where T: Storable {
    typealias ResultType = T
    private var results: Results<T>
    private var limitCount: Int?
    private var offsetCount: Int = 0

    init(realm: Realm) {
        results = realm.objects(T.self)
    }

    func filter(_ predicate: NSPredicate) -> Self {
        results = results.filter(predicate)
        return self
    }

    func sort(by keyPath: String, ascending: Bool) -> Self {
        results = results.sorted(byKeyPath: keyPath, ascending: ascending)
        return self
    }

    func limit(_ count: Int) -> Self {
        limitCount = count
        return self
    }

    func offset(_ count: Int) -> Self {
        offsetCount = count
        return self
    }

    func fetch() async throws -> [T] {
        var list = Array(results)
        if offsetCount > 0, offsetCount < list.count {
            list = Array(list.dropFirst(offsetCount))
        }
        if let l = limitCount, l < list.count {
            list = Array(list.prefix(l))
        }
        return list
    }

    func fetchFirst() async throws -> T? {
        var list = Array(results)
        if offsetCount > 0, offsetCount < list.count {
            list = Array(list.dropFirst(offsetCount))
        }
        return list.first
    }

    func count() async throws -> Int {
        var list = Array(results)
        if offsetCount > 0 { list = Array(list.dropFirst(offsetCount)) }
        if let l = limitCount { return min(l, list.count) }
        return list.count
    }
}

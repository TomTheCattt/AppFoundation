//
//  RealmStorage.swift
//  {{PROJECT_NAME}}
//

import Foundation
import RealmSwift

public class RealmStorage {
    private var realm: Realm?
    
    public init() {
        do {
            self.realm = try Realm()
        } catch {
            print("Failed to initialize Realm: \(error)")
        }
    }
    
    public func save<T: Object>(_ object: T) {
        try? realm?.write {
            realm?.add(object, update: .modified)
        }
    }
    
    public func fetch<T: Object>(_ type: T.Type) -> Results<T>? {
        return realm?.objects(type)
    }
    
    public func delete<T: Object>(_ object: T) {
        try? realm?.write {
            realm?.delete(object)
        }
    }
}

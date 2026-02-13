//
//  RealmMigration.swift
//  AppFoundation
//

import Foundation
import RealmSwift

enum RealmMigration {
    static func migrate(migration: Migration, oldSchemaVersion: UInt64) {
        if oldSchemaVersion < 1 {
            // Initial schema
        }
    }
}

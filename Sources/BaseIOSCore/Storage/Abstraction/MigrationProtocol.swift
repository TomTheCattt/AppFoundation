//
//  MigrationProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol MigrationProtocol {
    var targetVersion: UInt64 { get }
    func execute() throws
    func rollback() throws
}

protocol MigrationCoordinator {
    func performMigrations(from currentVersion: UInt64, to targetVersion: UInt64) throws
    func registerMigration(_ migration: MigrationProtocol)
}

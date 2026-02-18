//
//  CloudKitManager.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import CloudKit
import Combine

public final class CloudKitManager {
    public static let shared = CloudKitManager()
    
    private let container = CKContainer.default()
    private let database = CKContainer.default().privateCloudDatabase
    
    public init() {}
    
    /// Check iCloud Account Status
    public func checkAccountStatus() async throws -> CKAccountStatus {
        return try await container.accountStatus()
    }
    
    /// Save a generic record
    public func save(record: CKRecord) async throws -> CKRecord {
        return try await database.save(record)
    }
    
    /// Fetch records by type
    public func fetch(recordType: String) async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        // Use convenience API for simplicity (iOS 15+)
        let (matchResults, _) = try await database.records(matching: query)
        
        return matchResults.compactMap { _, result in
            try? result.get()
        }
    }
    
    /// Subscribe to changes
    public func subscribe(to recordType: String) async throws {
        let subscription = CKQuerySubscription(
            recordType: recordType,
            predicate: NSPredicate(value: true),
            options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
        )
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        try await database.save(subscription)
    }
}

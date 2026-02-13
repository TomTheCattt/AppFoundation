//
//  Notification+Extensions.swift
//  AppFoundation
//
//  Notification extensions for type-safe notifications.
//

import Foundation

extension Notification.Name {
    
    // MARK: - App Lifecycle
    
    /// Posted when user logs in
    static let userDidLogin = Notification.Name("userDidLogin")
    
    /// Posted when user logs out
    static let userDidLogout = Notification.Name("userDidLogout")
    
    // MARK: - Data Updates
    
    /// Posted when data is refreshed
    static let dataDidRefresh = Notification.Name("dataDidRefresh")
    
    /// Posted when sync completes
    static let syncDidComplete = Notification.Name("syncDidComplete")
}

extension NotificationCenter {
    
    // MARK: - Basic Helpers
    
    /// Posts a notification with optional user info
    /// - Parameters:
    ///   - name: Notification name
    ///   - object: Associated object
    ///   - userInfo: User info dictionary
    func postNotification(name: Notification.Name,
                          object: Any? = nil,
                          userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name,
                                        object: object,
                                        userInfo: userInfo)
    }
    
    // MARK: - Advanced Helpers
    
    /// Observes a notification with a closure
    /// - Parameters:
    ///   - name: Notification name
    ///   - object: Object to observe (optional)
    ///   - queue: Operation queue (default: main)
    ///   - handler: Notification handler closure
    /// - Returns: Observation token (must be retained)
    @discardableResult
    func observe(name: Notification.Name,
                object: Any? = nil,
                queue: OperationQueue = .main,
                handler: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: name, object: object, queue: queue, using: handler)
    }
}

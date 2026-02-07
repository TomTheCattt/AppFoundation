//
//  PendingSyncQueueProtocol.swift
//  BaseIOSApp
//

import Foundation

protocol PendingSyncQueueProtocol: AnyObject {
    func enqueue(_ item: PendingSyncItem) throws
    func dequeue(limit: Int) throws -> [PendingSyncItem]
    func remove(ids: [String]) throws
    func count() throws -> Int
    func removeAll() throws
}

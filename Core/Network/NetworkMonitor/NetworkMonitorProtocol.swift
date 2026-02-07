//
//  NetworkMonitorProtocol.swift
//  BaseIOSApp
//
//  Protocol for network connectivity status. Used by repositories for offline-first logic.
//

import Foundation

protocol NetworkMonitorProtocol: AnyObject {
    var isConnected: Bool { get }
}

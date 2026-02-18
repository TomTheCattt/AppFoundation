//
//  NetworkMonitorProtocol.swift
//  AppFoundation
//
//  Protocol for network connectivity status. Used by repositories for offline-first logic.
//

import Foundation

protocol NetworkMonitorProtocol: AnyObject, Sendable {
    var isConnected: Bool { get }
}

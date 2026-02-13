//
//  ThreadSafetyHelper.swift
//  AppFoundation
//

import Foundation

final class ThreadSafetyHelper {
    private let lock = NSLock()

    func sync<T>(_ block: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return block()
    }
}

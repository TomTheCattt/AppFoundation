//
//  DIContainer.swift
//  BaseIOSApp
//
//  Wrapper around Swinject Container. Type-safe resolution, fail-fast.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    private let lock = NSLock()

    private init() {}

    func resolve<T>(_ type: T.Type) -> T {
        lock.lock()
        defer { lock.unlock() }
        guard let resolved = container.resolve(type) else {
            fatalError("Unable to resolve \(T.self)")
        }
        return resolved
    }

    func register(_ assemblies: [Assembly]) {
        assemblies.forEach { $0.assemble(container: container) }
    }
}

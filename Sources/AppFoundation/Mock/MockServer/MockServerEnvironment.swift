//
//  MockServerEnvironment.swift
//  AppFoundation
//

import Foundation

struct MockServerEnvironment {
    var isEnabled: Bool
    var defaultDelay: TimeInterval
    var shouldLogRequests: Bool
    var errorRate: Double

    static var standard: MockServerEnvironment {
        MockServerEnvironment(
            isEnabled: AppEnvironment.current == .mock,
            defaultDelay: 0.5,
            shouldLogRequests: true,
            errorRate: 0
        )
    }
}

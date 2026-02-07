//
//  ValidationHelper.swift
//  BaseIOSApp
//

import Foundation

enum ValidationHelper {
    static func isValidEmail(_ string: String) -> Bool {
        let pattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
        return string.range(of: pattern, options: .regularExpression) != nil
    }
}

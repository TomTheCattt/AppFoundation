//
//  DispatchQueue+Extensions.swift
//  AppFoundation
//

import Foundation

extension DispatchQueue {
    static func asyncOnMain(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.async(execute: work)
        }
    }
}

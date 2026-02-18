//
//  Binding+Extensions.swift
//  AppFoundation
//
//  Binding helpers for optional and default values.
//

import SwiftUI

extension Binding where Value == String? {
    func withDefault(_ defaultValue: String) -> Binding<String> {
        Binding<String>(
            get: { wrappedValue ?? defaultValue },
            set: { wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
}

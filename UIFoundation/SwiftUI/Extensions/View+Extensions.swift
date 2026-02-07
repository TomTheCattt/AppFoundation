//
//  View+Extensions.swift
//  BaseIOSApp
//
//  SwiftUI View extensions.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

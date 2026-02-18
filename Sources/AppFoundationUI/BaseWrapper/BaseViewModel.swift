//
//  BaseViewModel.swift
//  AppFoundationUI
//
//  Created by AppFoundation Package.
//

import Combine
import Foundation

@MainActor
open class BaseViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    public init() {}
    
    open func viewDidLoad() {}
}

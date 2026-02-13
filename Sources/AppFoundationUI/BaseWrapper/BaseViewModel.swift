//
//  BaseViewModel.swift
//  AppFoundationUI
//
//  Created by AppFoundation Package.
//

import Foundation
import Combine

open class BaseViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var error: Error? = nil
    
    public init() {}
    
    open func viewDidLoad() {}
}

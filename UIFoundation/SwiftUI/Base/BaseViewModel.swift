//
//  BaseViewModel.swift
//  BaseIOSApp
//
//  Base ViewModel with DI and logging. Override handle(error:) for custom error handling.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {

    var cancellables = Set<AnyCancellable>()
    let logger: Logger
    let container: DIContainer

    init(container: DIContainer = .shared) {
        self.container = container
        self.logger = container.resolve(Logger.self)
        logger.debug("[\(type(of: self))] initialized")
    }

    deinit {
        logger.debug("[\(type(of: self))] deinitialized")
    }

    func handle(_ error: Error) {
        logger.error("Error: \(error.localizedDescription)")
    }
}

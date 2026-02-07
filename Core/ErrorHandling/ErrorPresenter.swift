//
//  ErrorPresenter.swift
//  BaseIOSApp
//

import UIKit

final class ErrorPresenter {
    private let logger = Logger.shared

    func present(_ error: AppErrorProtocol, in viewController: UIViewController) {
        logger.error("Error presented: \(error.code) - \(error.message)")
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        if let strategy = error.recoveryStrategy {
            for action in strategy.actions {
                alert.addAction(UIAlertAction(title: action.title, style: action.style) { _ in action.handler() })
            }
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }

    func present(_ error: Error, in viewController: UIViewController) {
        present(ErrorMapper().map(error), in: viewController)
    }
}

//
//  UITableView+Extensions.swift
//  AppFoundation
//
//  UITableView extensions for cell registration and dequeuing.
//

import UIKit

extension UITableView {
    
    // MARK: - Basic Helpers
    
    /// Registers a cell class for reuse
    /// - Parameter cellClass: The cell class to register
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    /// Dequeues a reusable cell
    /// - Parameters:
    ///   - cellClass: The cell class to dequeue
    ///   - indexPath: Index path for the cell
    /// - Returns: Dequeued cell of the specified type
    func dequeue<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            fatalError("Unable to dequeue \(String(describing: cellClass))")
        }
        return cell
    }
    
    // MARK: - Advanced Helpers
    
    /// Scrolls to the top of the table view
    /// - Parameter animated: Whether to animate the scroll
    func scrollToTop(animated: Bool = true) {
        guard numberOfSections > 0, numberOfRows(inSection: 0) > 0 else { return }
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
    
    /// Scrolls to the bottom of the table view
    /// - Parameter animated: Whether to animate the scroll
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: lastSection) - 1
        guard lastRow >= 0 else { return }
        scrollToRow(at: IndexPath(row: lastRow, section: lastSection), at: .bottom, animated: animated)
    }
    
    /// Reloads data with a fade animation
    /// - Parameter duration: Animation duration (default: 0.3)
    func reloadWithAnimation(duration: TimeInterval = 0.3) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.reloadData()
        })
    }
}

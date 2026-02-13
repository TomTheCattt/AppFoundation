//
//  UICollectionView+Extensions.swift
//  AppFoundation
//
//  UICollectionView extensions for cell registration and dequeuing.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Basic Helpers
    
    /// Registers a cell class for reuse
    /// - Parameter cellClass: The cell class to register
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    /// Dequeues a reusable cell
    /// - Parameters:
    ///   - cellClass: The cell class to dequeue
    ///   - indexPath: Index path for the cell
    /// - Returns: Dequeued cell of the specified type
    func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            fatalError("Unable to dequeue \(String(describing: cellClass))")
        }
        return cell
    }
    
    // MARK: - Advanced Helpers
    
    /// Scrolls to the top of the collection view
    /// - Parameter animated: Whether to animate the scroll
    func scrollToTop(animated: Bool = true) {
        guard numberOfSections > 0, numberOfItems(inSection: 0) > 0 else { return }
        scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: animated)
    }
    
    /// Scrolls to the bottom of the collection view
    /// - Parameter animated: Whether to animate the scroll
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        scrollToItem(at: IndexPath(item: lastItem, section: lastSection), at: .bottom, animated: animated)
    }
    
    /// Reloads data with a fade animation
    /// - Parameter duration: Animation duration (default: 0.3)
    func reloadWithAnimation(duration: TimeInterval = 0.3) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.reloadData()
        })
    }
}

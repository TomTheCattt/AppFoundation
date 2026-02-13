//
//  CustomTransitions.swift
//  AppFoundation
//
//  Custom transition delegate for modal presentations.
//

import UIKit

final class FadeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TransitionAnimator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TransitionAnimator(isPresenting: false)
    }
}

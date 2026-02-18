//
//  TransitionAnimator.swift
//  AppFoundation
//
//  Custom transition animator for view controller presentations.
//

import UIKit

final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: TimeInterval
    let isPresenting: Bool

    init(duration: TimeInterval = 0.3, isPresenting: Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresent(using: transitionContext)
        } else {
            animateDismiss(using: transitionContext)
        }
    }

    private func animatePresent(using context: UIViewControllerContextTransitioning) {
        guard let toView = context.view(forKey: .to) else {
            context.completeTransition(false)
            return
        }
        let container = context.containerView
        toView.alpha = 0
        container.addSubview(toView)
        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }

    private func animateDismiss(using context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from) else {
            context.completeTransition(false)
            return
        }
        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }
}

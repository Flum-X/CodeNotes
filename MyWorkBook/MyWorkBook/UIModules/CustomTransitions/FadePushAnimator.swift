//
//  FadePushAnimator.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/31.
//

import UIKit

class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            toVC.view.alpha = 1.0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

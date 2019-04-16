//
//  SlideInAnimator.swift
//  skarbnik
//
//  Created by Jakub Towarek on 15/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class SlideInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard   let toVC = transitionContext.viewController(forKey: .to) as? Slidable,
                let fromVC = transitionContext.viewController(forKey: .from) as? Slidable else {
                    containerView.addSubview(transitionContext.view(forKey: .to)!)
                    print("Used slide transition on ViewController that doesn't conforms to Slidable protocool.")
                    return
        }
        
        fromVC.slideOut()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            fromVC.view.layoutIfNeeded()
        }, completion: { succeed  in
            containerView.addSubview(toVC.view)
            
            toVC.slideIn()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                toVC.view.layoutIfNeeded()
            }, completion: { succeed  in
                transitionContext.completeTransition(true)
            })
        })
            
        
    }
    
    
    
}

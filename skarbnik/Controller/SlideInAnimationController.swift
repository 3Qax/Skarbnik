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
        
        guard let toView = transitionContext.view(forKey: .to) as? Slidable,
            let fromView = transitionContext.view(forKey: .from) as? Slidable else {
                    containerView.addSubview(transitionContext.view(forKey: .to)!)
                    print("Used slide transition on ViewController that doesn't conforms to Slidable protocool.")
                    return
        }
        
        fromView.slideOut(completion: {
            containerView.addSubview(toView)
            toView.slideIn(completion: {
                transitionContext.completeTransition(true)
            })
        })
    }
    
    
}

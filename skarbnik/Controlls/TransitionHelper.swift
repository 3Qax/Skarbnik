//
//  TransitionHelper.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class TransitionHelper: UIView {
    var touchesBeganHandler: ((Set<UITouch>, UIEvent?) -> ())?
    var touchesMovedHandler: ((CGFloat, Set<UITouch>, UIEvent?) -> ())?
    var touchesEndedHandler: ((Set<UITouch>, UIEvent?) -> ())?
    var previousPosition = CGPoint()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousPosition = touches.first!.location(in: superview)
        touchesBeganHandler!(touches, event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dy =  previousPosition.y - touches.first!.location(in: superview).y
        touchesMovedHandler!(dy, touches, event)
        previousPosition = touches.first!.location(in: superview)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedHandler!(touches, event)
    }
}

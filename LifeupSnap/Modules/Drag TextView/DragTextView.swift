//
//  DragTextView.swift
//  LifeupSnap
//
//  Created by lifeup on 14/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class DragTextView: GrowingTextView {
    var lastLocation: CGPoint!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        lastLocation = CGPoint(x: 0, y: 0)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        self.gestureRecognizers = [panGesture]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc fileprivate func panView(_ gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: self.superview)
        center = CGPoint(x: lastLocation.x + transition.x, y: lastLocation.y + transition.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        lastLocation = center
    }
}

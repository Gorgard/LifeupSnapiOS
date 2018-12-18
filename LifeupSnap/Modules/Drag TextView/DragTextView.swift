//
//  DragTextView.swift
//  LifeupSnap
//
//  Created by lifeup on 14/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class DragTextView: GrowingTextView {
    private var lastLocation: CGPoint!
    private var lastScale: CGFloat = 1.0
    
    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 2.0
    
    internal var currentColor: LFSColor?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func configuration() {
        lastLocation = CGPoint(x: 0, y: 0)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchView(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        tapGesture.numberOfTapsRequired = 2
        
        self.gestureRecognizers = [panGesture, pinchGesture, tapGesture]
        
        isScrollEnabled = false
    }
    
    @objc fileprivate func panView(_ gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: self.superview)
        center = CGPoint(x: lastLocation.x + transition.x, y: lastLocation.y + transition.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        lastLocation = center
    }
    
    @objc fileprivate func pinchView(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let pinchScale: CGFloat = gesture.scale
            
            if lastScale * pinchScale < maxScale && lastScale * pinchScale > minScale {
                lastScale *= pinchScale
                transform = transform.scaledBy(x: pinchScale, y: pinchScale)
            }
            
            gesture.scale = 1.0
        }
    }
    
    @objc fileprivate func tapView(_ gesture: UITapGestureRecognizer) {
        let userInfo: [String: Any] = ["dragTextView": self]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LFSConstants.NotificationCenterID.DragTextView.editTextView), object: nil, userInfo: userInfo)
    }
}

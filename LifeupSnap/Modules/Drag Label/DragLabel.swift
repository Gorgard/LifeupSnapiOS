//
//  DragLabel.swift
//  LifeupSnap
//
//  Created by lifeup on 14/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class DragLabel: UILabel {
    private var lastLocation: CGPoint!
    private var lastScale: CGFloat = 1.0
    
    private let kMinScale: CGFloat = 0.5
    private let kMaxScale: CGFloat = 2.0
    
    internal var currentColor: LFSColor?
    internal var currentWidth: CGFloat!
    internal var currentHeight: CGFloat!
    
    internal var borderTextColor: UIColor?
    internal var isBorder: Bool = false

    private var borderPath: UIBezierPath!
    private var borderLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        currentWidth = 300
        currentHeight = 300
        
        isUserInteractionEnabled = true
        numberOfLines = 0
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    
    internal func setBorderLabel() {
        if isBorder {
            layer.cornerRadius = 8
            layer.masksToBounds = true
            layer.backgroundColor = borderTextColor?.cgColor
        }
    }
}

//MARK: Handle Event
extension DragLabel {
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
            
            if lastScale * pinchScale < kMaxScale && lastScale * pinchScale > kMinScale {
                lastScale *= pinchScale
                transform = transform.scaledBy(x: pinchScale, y: pinchScale)
                
                if let view = gesture.view {
                    currentWidth = view.frame.size.width * pinchScale
                    currentHeight = view.frame.size.height * pinchScale
                }
            }
            
            gesture.scale = 1.0
        }
    }
    
    @objc fileprivate func tapView(_ gesture: UITapGestureRecognizer) {
        let userInfo: [String: Any] = ["dragLabel": self]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LFSConstants.NotificationCenterID.DragLabel.editLabel), object: nil, userInfo: userInfo)
    }
}

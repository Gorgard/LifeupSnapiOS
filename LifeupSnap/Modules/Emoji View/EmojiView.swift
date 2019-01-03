//
//  EmojiView.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class EmojiView: UIView {
    private var lastLocation: CGPoint!
    private var lastScale: CGFloat = 1.0
    
    private let kMinScale: CGFloat = 0.5
    private let kMaxScale: CGFloat = 2.0
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapView(_:)))
        tapGesture.numberOfTapsRequired = 2
        
        self.gestureRecognizers = [panGesture, pinchGesture, tapGesture]
        
        isUserInteractionEnabled = true
        backgroundColor = .clear
    }
    
    internal func addImage(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        addSubview(imageView)
    }
}

//MARK: Handle Event
extension EmojiView {
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
            }
            
            gesture.scale = 1.0
        }
    }
    
    @objc fileprivate func doubleTapView(_ gesture: UITapGestureRecognizer) {
        lastScale = 1
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.transform = .identity
        })
    }
}

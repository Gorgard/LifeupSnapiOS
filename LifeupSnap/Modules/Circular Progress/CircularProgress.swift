//
//  CircularProgress.swift
//  LifeupSnapTest
//
//  Created by lifeup on 4/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation

internal class CircularProgress: NSObject {
    private var shapeLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private var circularPath: UIBezierPath!
    private var baseView: UIView!
    private var circularView: UIView!
    private var duration: CFTimeInterval!
    
    internal var shapeStrokeColor: CGColor = UIColor.red.cgColor
    internal var shapeFillColor: CGColor = UIColor.clear.cgColor
    internal var shapeLineWidth: CGFloat = 10
    
    internal var trackStrokeColor: CGColor = UIColor.lightGray.cgColor
    internal var trackFillColor: CGColor = UIColor.clear.cgColor
    internal var trackLineWidth: CGFloat = 10
    
    init(baseView: UIView, duration: CFTimeInterval) {
        super.init()
        self.baseView = baseView
        self.duration = duration
    }
    
    internal func createCircularProgress() {
        createCircularView()
        createTrackLayer()
        createShapeLayer()
    }
    
    private func createTrackLayer() {
        trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = trackStrokeColor
        trackLayer.fillColor = trackFillColor
        trackLayer.lineWidth = trackLineWidth
        trackLayer.lineCap = kCALineCapRound
        
        circularView.layer.addSublayer(trackLayer)
    }
    
    private func createShapeLayer() {
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = shapeStrokeColor
        shapeLayer.fillColor = shapeFillColor
        shapeLayer.lineWidth = shapeLineWidth
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        
        circularView.layer.addSublayer(shapeLayer)
    }
    
    private func createCircularView() {
        circularView = UIView(frame: CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height))
        baseView.addSubview(circularView)
        
        circularView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0).isActive = true
        circularView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0).isActive = true
        circularView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 0).isActive = true
        circularView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: 0).isActive = true
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi
        
        circularPath = UIBezierPath(arcCenter: circularView.center, radius: circularView.bounds.size.height / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    internal func startProgress() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = true
        
        let seconds = Double(duration)
        let preferredTimeScale = 1
        let maxRecordDuration = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(preferredTimeScale))
        
        animation.duration = maxRecordDuration.seconds
        
        shapeLayer.add(animation, forKey: "CIRCULAR")
    }
    
    internal func removeProgress() {
        if let _ = circularView {
            shapeLayer.strokeEnd = 0
            shapeLayer.removeAllAnimations()
        }
    }
}


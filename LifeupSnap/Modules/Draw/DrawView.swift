//
//  DrawView.swift
//  LifeupSnap
//
//  Created by lifeup on 17/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class DrawView: UIView {
    internal var lines: [LFSLine]!
    internal var lastPoint: CGPoint!
    internal var currentColor: LFSColor!
    internal var lineWidth: CGFloat!
    
    private var deletedLines: [LFSLine]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineCap(.round)
            context.setLineWidth(lineWidth)
            
            for line in lines {
                context.beginPath()
                context.move(to: CGPoint(x: line.startX, y: line.startY))
                context.addLine(to: CGPoint(x: line.endX, y: line.endY))
                context.setStrokeColor(line.color.cgColor)
                context.setLineWidth(line.lineWidth)
                context.strokePath()
            }
        }
    }
    
    fileprivate func configuration() {
        lines = [LFSLine]()
        deletedLines = [LFSLine]()
        currentColor = LFSColor(name: "Black", color: .black)
        lineWidth = 1
    }
    
    internal func backward() {
        if let line = lines.last {
            deletedLines.append(line)
            lines.removeLast()
            
            setNeedsDisplay()
        }
    }
    
    internal func forward() {
        if let line = deletedLines.last {
            lines.append(line)
            deletedLines.removeLast()
            
            setNeedsDisplay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let newPoint = touch.location(in: self)
            let line = LFSLine(startPoint: lastPoint, endPoint: newPoint, color: currentColor, width: lineWidth)
            
            lines.append(line)
            lastPoint = newPoint
            
            setNeedsDisplay()
        }
    }
}

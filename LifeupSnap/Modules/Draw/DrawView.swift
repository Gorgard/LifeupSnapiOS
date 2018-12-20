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
    
    private var deletedLines: [LFSLine]!
    
    internal var lastPoint: CGPoint!
    
    internal var currentColor: LFSColor!
    internal var lineWidth: CGFloat!
    
    private var defaultLineWidth: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineCap(.round)
            
            for line in lines {
                context.beginPath()
                context.move(to: CGPoint(x: line.startX, y: line.startY))
                context.addLine(to: CGPoint(x: line.endX, y: line.endY))
                context.setLineWidth(line.lineWidth)
                
                if line.color == .clear {
                    context.setBlendMode(.clear)
                }
                else {
                    context.setBlendMode(.normal)
                    context.setStrokeColor(line.color.cgColor)
                }
                
                context.strokePath()
                context.fillPath()
            }
        }
    }
    
    fileprivate func configuration() {
        isOpaque = false
        backgroundColor = .clear
        
        lines = [LFSLine]()
        deletedLines = [LFSLine]()
        currentColor = LFSColor(name: "Black", color: .black)
        lineWidth = defaultLineWidth
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
    
    internal func clear() {
        if lines.count > 0 {
            lines.removeAll()
        }
        
        setNeedsDisplay()
    }
    
    internal func image() -> UIImage {
        let rendererImage = renderImage()
        return rendererImage
    }
    
    fileprivate func renderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image(actions: { [unowned self] (rendererContext) in
            self.layer.render(in: rendererContext.cgContext)
        })
        
        return image
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

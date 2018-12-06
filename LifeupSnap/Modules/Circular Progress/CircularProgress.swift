//  ProgressView.swift

import UIKit

internal class CircularProgress: UIView {
    private var progressLayer: CAShapeLayer!

    internal var duration: CFTimeInterval!
    
    internal var bgColor: CGColor? = nil {
        willSet(_bgColor) {
            if let _ = progressLayer {
                progressLayer.backgroundColor = _bgColor
            }
        }
    }
    
    internal var fillColor: CGColor? = nil {
        willSet(_fillColor) {
            if let _ = progressLayer {
                progressLayer.fillColor = _fillColor
            }
        }
    }
    
    internal var strokeColor: CGColor? = nil {
        willSet(_strokeColor) {
            if let _ = progressLayer {
                progressLayer.strokeColor = _strokeColor
            }
        }
    }
    
    internal var lineWidth: CGFloat = 0 {
        willSet(width) {
            if let _ = progressLayer {
                progressLayer.lineWidth = width
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createProgressLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createProgressLayer()
    }
    
    private func createProgressLayer() {
        let startAngle = -CGFloat.pi / 2
        let endAngle = CGFloat.pi * 2
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        progressLayer = CAShapeLayer()
        progressLayer.path = UIBezierPath(arcCenter:center, radius: self.bounds.height / 2, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        progressLayer.backgroundColor = bgColor
        progressLayer.fillColor = fillColor
        progressLayer.strokeColor = UIColor.orange.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0

        layer.addSublayer(progressLayer)
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0
        progressLayer.removeAllAnimations()
    }
    
    func animateProgressView() {
        progressLayer.strokeEnd = 0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = kCAFillModeForwards
        progressLayer.add(animation, forKey: "strokeEnd")
    }
}

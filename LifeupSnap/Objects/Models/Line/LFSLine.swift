//
//  LFSLine.swift
//  LifeupSnap
//
//  Created by lifeup on 17/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal struct LFSLine {
    private var startPoint: CGPoint
    private var endPoint: CGPoint
    private var lfsColor: LFSColor
    private var width: CGFloat
    
    internal var startX: CGFloat {
        get {
            return startPoint.x
        }
    }
    
    internal var startY: CGFloat {
        get {
            return startPoint.y
        }
    }
    
    internal var endX: CGFloat {
        get {
            return endPoint.x
        }
    }
    
    internal var endY: CGFloat {
        get {
            return endPoint.y
        }
    }
    
    internal var color: UIColor {
        get {
            return lfsColor.color
        }
    }
    internal var lineWidth: CGFloat {
        get {
            return width
        }
    }
    
    init(startPoint: CGPoint, endPoint: CGPoint, color: LFSColor, width: CGFloat) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.lfsColor = color
        self.width = width
    }
}

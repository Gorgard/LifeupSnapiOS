//
//  UIImageExtension.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal extension UIImage {
    internal func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        imageView.layer.render(in: context)
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    internal func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        imageView.layer.render(in: context)
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        return result
    }
}

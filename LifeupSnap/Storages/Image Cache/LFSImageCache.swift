//
//  LFSImageCache.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSImageCache: NSObject {
    internal static let shared: LFSImageCache = LFSImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    
    private override init() {
        super.init()
        
        observer = NotificationCenter.default.addObserver(forName: .UIApplicationDidReceiveMemoryWarning, object: nil, queue: nil, using: { [weak self] (notification) -> Void in
            self?.cache.removeAllObjects()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
    
    internal func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    internal func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

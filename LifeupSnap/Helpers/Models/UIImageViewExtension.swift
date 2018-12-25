//
//  UIImageViewExtension.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal extension UIImageView {
    private static var taskKey: Int = 0
    private static var urlKey: Int = 0
    
    private var currentTask: URLSessionTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var currentURL: URL? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal func lfsImageCache(with urlString: String?) {
        var loadingView: UIActivityIndicatorView? = UIActivityIndicatorView(frame: bounds)
        loadingView?.center = center
        loadingView?.color = .darkGray
        loadingView?.hidesWhenStopped = true
        loadingView?.startAnimating()
        
        addSubview(loadingView!)
        
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        image = nil
        
        guard let urlString = urlString else { return }
        
        if let cachedImage = LFSImageCache.shared.image(forKey: urlString) {
            loadingView?.removeFromSuperview()
            loadingView?.stopAnimating()
            loadingView = nil
            
            image = cachedImage
            return
        }
        
        let url = URL(string: urlString)!
        currentURL = url
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) -> Void in
            self?.currentTask = nil
            
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                case 200...299:
                    guard let data = data, let downloadedImage = UIImage(data: data) else {
                        print("Unable to extract image.")
                        return
                    }
                    
                    LFSImageCache.shared.save(image: downloadedImage, forKey: urlString)
                    
                    if url == self?.currentURL {
                        taskMain {
                            loadingView?.removeFromSuperview()
                            loadingView?.stopAnimating()
                            loadingView = nil
                            
                            self?.image = downloadedImage
                        }
                    }
                    
                    break
                default:
                    print("LFSImageCache Cannot load image.")
                    
                    break
                }
            }
        }
        
        currentTask = task
        task.resume()
    }
}

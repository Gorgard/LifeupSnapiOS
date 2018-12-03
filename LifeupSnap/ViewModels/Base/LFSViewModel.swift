//
//  LFSViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSViewModel: NSObject, LFSViewPresentable {
    var boomerangView: UIView?
    var squareView: UIView?
    var originalView: UIView?
    var videoView: UIView?
    
    var viewController: UIViewController?
    var navigationController: UINavigationController?
    
    internal func close() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
}

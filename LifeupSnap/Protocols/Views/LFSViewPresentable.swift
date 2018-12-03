//
//  ViewPresentable.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal protocol LFSViewPresentable: NSObjectProtocol {
    var boomerangView: UIView? { get set }
    var squareView: UIView? { get set }
    var originalView: UIView? { get set }
    var videoView: UIView? { get set }
    
    var viewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }
}

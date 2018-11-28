//
//  ViewPresentable.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

protocol LFSViewPresentable: NSObjectProtocol {
    var view: UIView? { get set }
    var viewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }
}

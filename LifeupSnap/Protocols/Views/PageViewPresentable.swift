//
//  PageViewPresentable.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal protocol PageViewPresentable {
    func beforeViewController(pageViewController: UIPageViewController, viewController: UIViewController) -> UIViewController?
    func afterViewController(pageViewController: UIPageViewController, viewController: UIViewController) -> UIViewController?
}

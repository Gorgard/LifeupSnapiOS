//
//  PageViewPresentable.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

protocol PageViewPresentable {
    func beforeViewController(pageViewController: UIPageViewController, viewController: UIViewController) -> UIViewController?
    func afterViewController(pageViewController: UIPageViewController, viewController: UIViewController) -> UIViewController?
    func presentationCount() -> Int
    func presentationIndex() -> Int
}

//
//  LFSViewUtils.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSViewUtils: NSObject {
    static func addSubView(withBase viewController: UIViewController, and childController: UIViewController, by view: UIView) {
        view.frame = CGRect(x: 0, y: 0, width: childController.view.bounds.width, height: childController.view.bounds.height)
        viewController.addChildViewController(childController)
        view.addSubview(childController.view)
    }
    
    static func addSubViewByWindow(viewController: UIViewController) {
        let window = UIApplication.shared.delegate?.window
        window??.addSubview(viewController.view)
    }
    
    static func goToSpecifyViewController(with navigationController: UINavigationController, to viewController: UIViewController, hideBottomBar: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            viewController.hidesBottomBarWhenPushed = hideBottomBar
            navigationController.pushViewController(viewController, animated: true)
        })
    }
    
    static func presentViewController(with navigationController: UINavigationController, and viewController: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            viewController.modalPresentationStyle = .overFullScreen
            navigationController.present(viewController, animated: true, completion: nil)
        })
    }
}

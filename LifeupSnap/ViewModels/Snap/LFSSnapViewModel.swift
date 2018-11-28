//
//  LFSSnapViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSSnapViewModel: LFSViewModel {
    private weak var delegate: LFSSnapViewModelDelegate?
    
    private var viewControllers: [UIViewController]!
    
    var receivedFirstPage: ((_ viewController: UIViewController) -> Void)?
    
    init(delegate: LFSSnapViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        storeViewControllers()
    }
    
    private func storeViewControllers() {
        viewControllers = [LFSBoomerangViewController(),
                           LFSSquareCaptureViewController(),
                           LFSOriginalCaptureViewController(),
                           LFSVideoCaptureViewController()]
    }
    
    internal func binding() {
        receivedFirstPage?(viewControllerAtIndex(0)!)
    }
}

//MARK: PageViewPresentable
extension LFSSnapViewModel: PageViewPresentable {
    func beforeViewController(pageViewController: UIPageViewController, viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func afterViewController(pageViewController: UIPageViewController, viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == viewControllers.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCount() -> Int {
        return viewControllers.count
    }
    
    func presentationIndex() -> Int {
        return 0
    }
}

//MARK: Helpers
extension LFSSnapViewModel {
    private func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if viewControllers.count == 0 || index >= viewControllers.count {
            return nil
        }
        return viewControllers[index]
    }
    
    private func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers.index(of: viewController) ?? NSNotFound
    }
}

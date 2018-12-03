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
    
    internal var viewControllers: [LFSFeature]!
    internal var features: [CameraFeature]!
    
    private var feature: CameraFeature!
    
    private var currentIndex: Int = 1
    private var initialed: Bool = false
    
    open var receivedFirstPage: ((_ viewController: UIViewController) -> Void)?
    open var receivedFirstFeature: ((_ index: Int) -> Void)?
    
    init(delegate: LFSSnapViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    internal func setup() {
        viewControllers = [LFSFeature]()
        
        let _viewControllers = [LFSFeature(viewController: LFSVideoCaptureViewController(), name: LFSConstants.LFSFeatureName.Snap.video, isCurrent: false),
                           LFSFeature(viewController: LFSOriginalCaptureViewController(), name: LFSConstants.LFSFeatureName.Snap.photo, isCurrent: false),
                           LFSFeature(viewController: LFSSquareCaptureViewController(), name: LFSConstants.LFSFeatureName.Snap.square, isCurrent: false),
                           LFSFeature(viewController: LFSBoomerangViewController(), name: LFSConstants.LFSFeatureName.Snap.boomerang, isCurrent: false)]
        
        features = features.sorted(by: { $0.rawValue > $1.rawValue })
        
        if let _features = features {
            for feature in _features {
                let viewController = _viewControllers.filter({ $0.name == feature.rawValue }).first
                viewControllers.append(viewController!)
            }
        }
        else {
            features = [.original]
        }
    }
    
    internal func binding() {
        if !initialed {
            currentIndex = features.index(of: .original)!
            feature = .original
            initialed = true
        }
        
        if let _ = viewControllers[safe: currentIndex] {
            feature = features[currentIndex]
            
            viewControllers[currentIndex].isCurrent = true
            
            receivedFirstPage?(viewControllers[currentIndex].viewController)
            receivedFirstFeature?(currentIndex)
        }
    }
}

//MARK: PickerViewPresentable
extension LFSSnapViewModel: PickerViewPresentable {
    func numberOfComponents(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfRowsInComponent(pickerView: UIPickerView, component: Int) -> Int {
        return features.count
    }
    
    func viewForRow(pickerView: UIPickerView, row: Int, component: Int, view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.text = features[row].rawValue
        label.textColor = viewControllers[row].isCurrent ? UIColor.yellow : UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        
        return label
    }
    
    func didSelected(pickerView: UIPickerView, row: Int, component: Int) {
        currentIndex = row
        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
}

//MARK: ACTION Handle
extension LFSSnapViewModel {
    internal func flip() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
    }
    
    internal func flash() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
    }
    
    internal func snap() {
        switch feature {
        case .boomerang:
            NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapBoomerang), object: nil)
            break
        case .original:
            NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapPhoto), object: nil)
            break
        case .square:
            NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapSquare), object: nil)
            break
        case .video:
            NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapVideo), object: nil)
            break
        default:
            break
        }
    }
}

//MARK: Handle SwipeGesture
extension LFSSnapViewModel {
    internal func handleSwipeRight() {
        if currentIndex == NSNotFound {
            return
        }
        
        currentIndex += 1
        
        if currentIndex > viewControllers.count - 1 {
            currentIndex = viewControllers.count - 1
        }
    
        if currentIndex == viewControllers.count {
            return
        }
        
        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
    
    internal func handleSwipeLeft() {
        if currentIndex == 0 || currentIndex == NSNotFound {
            return
        }
        
        currentIndex -= 1

        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
}

//MARK: Handle Methods
extension LFSSnapViewModel {
    fileprivate func setNotCurrent(currentIndex: Int) {
        for i in 0..<viewControllers.count {
            viewControllers[i].isCurrent = false
        }
    }
}

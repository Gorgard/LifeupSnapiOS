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
    
    internal var circularProgress: CircularProgress!
    
    internal var snapButtonBounds: CGRect!
    
    private var currentIndex: Int = 1
    private var initialed: Bool = false
    
    open var receivedFirstPage: ((_ viewController: UIViewController) -> Void)?
    open var receivedFirstFeature: ((_ index: Int) -> Void)?
    open var hiddenBlurView: ((_ alpha: CGFloat) -> Void)?
    open var changeSnapButtonColor: ((_ color: UIColor) -> Void)?
    open var enableAllView: ((_ enable: Bool) -> Void)?
    open var changeSnapButtonRadius: ((_ radius: CGFloat, _ bounds: CGRect) -> Void)?
    open var changeImageFlashButton: ((_ image: UIImage) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapBoomerang), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapPhoto), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapSquare), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapVideo), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.finishedSnapVideo), object: nil)
    }
    
    init(delegate: LFSSnapViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishedSnapVideo), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.finishedSnapVideo), object: nil)
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
        
        if let _viewController = viewControllers[safe: currentIndex] {
            feature = features[currentIndex]
            
            viewControllers[currentIndex].isCurrent = true
            
            receivedFirstPage?(viewControllers[currentIndex].viewController)
            receivedFirstFeature?(currentIndex)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [unowned self] in
                self.hiddenBlurView?(0)
            })
            
            changeSnapButtonColor?(viewControllers[currentIndex].name == CameraFeature.video.rawValue ? .red : .white)
            
            if !(_viewController.name == CameraFeature.video.rawValue) {
                removeCircularProgress()
            }
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
        hiddenBlurView?(1)
        
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
        if Camera.flashMode == .off {
            changeImageFlashButton?(#imageLiteral(resourceName: "ic_main_flash_on.png"))
        }
        else {
            changeImageFlashButton?(#imageLiteral(resourceName: "ic_main_flash_off.png"))
        }
        
        //changeImageFlashButton?(Camera.flashMode == .off ? #imageLiteral(resourceName: "ic_main_flash_off.png") : #imageLiteral(resourceName: "ic_main_flash_on.png"))
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
            DispatchQueue.main.async { [unowned self] in
                self.changeSnapButtonRadius?(8, CGRect(x: 0, y: 0, width: 40, height: 40))
                self.enableAllView?(false)
            }
            
            startProgress()
            
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
        
        hiddenBlurView?(1)
        
        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
    
    internal func handleSwipeLeft() {
        if currentIndex == 0 || currentIndex == NSNotFound {
            return
        }
        
        currentIndex -= 1
        
        hiddenBlurView?(1)

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

//MARK: Notification Handle
extension LFSSnapViewModel {
    @objc fileprivate func finishedSnapVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.changeSnapButtonRadius?(self.snapButtonBounds.size.height / 2, self.snapButtonBounds)
            self.enableAllView?(true)
        }
        
        removeCircularProgress()
    }
}

//MARK: Circular Progress
extension LFSSnapViewModel {
    fileprivate func startProgress() {
        circularProgress.duration = 30
        circularProgress.bgColor = UIColor.clear.cgColor
        circularProgress.strokeColor = UIColor.orange.cgColor
        circularProgress.lineWidth = 4
        circularProgress.animateProgressView()
    }
    
    fileprivate func removeCircularProgress() {
        if let _ = circularProgress {
            circularProgress.hideProgressView()
        }
    }
}

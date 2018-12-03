//
//  LFSOriginalCaptureViewModel.swift
//  LifeupSnapTest
//
//  Created by lifeup on 3/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSOriginalCaptureViewModel: LFSViewModel {
    private weak var delegate: LFSOriginalCaptureViewModelDelegate?
    
    private var camera: Camera!
    
    private var image: UIImage?
    
    internal var hiddenBlurView: ((_ alpha: CGFloat) -> Void)?
    
    init(delegate: LFSOriginalCaptureViewModelDelegate) {
        super.init()
        self.delegate = delegate
        camera = Camera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(flip), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flash), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(snapOriginal), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapPhoto), object: nil)
    }
    
    internal func startOriginalCapture() {
        camera.prepare(completion: { [weak self] () -> Void in
            try? self?.camera.displayPreview()
            self?.camera.addPreviewLayer(view: (self?.originalView)!)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    internal func begin() {
        if camera.initialed {
            startOriginalCapture()
            binding()
        }
    }
    
    internal func binding() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.hiddenBlurView?(0)
        })
    }
    
    internal func willDisappear() {
        hiddenBlurView?(1)
    }
}

//MARK: Handle Notification
extension LFSOriginalCaptureViewModel {
    @objc private func flip() {
        try? camera.switchCamera()
    }
    
    @objc private func flash() {
        if Camera.flashMode == .on {
            Camera.flashMode = .off
        }
        else {
            Camera.flashMode = .on
        }
    }
    
    @objc private func snapOriginal() {
        camera.captureImage(completion: { [weak self] (image) -> Void in
            self?.image = image
            self?.delegate?.didReceivedImage()
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}


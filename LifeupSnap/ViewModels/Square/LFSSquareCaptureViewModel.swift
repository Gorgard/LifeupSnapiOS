//
//  LFSSquareCaptureViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 29/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSSquareCaptureViewModel: LFSViewModel {
    private weak var delegate: LFSSquareCaptureViewModelDelegate?
    
    private var camera: Camera!
    
    private var image: UIImage?
    
    internal var hiddenBlurView: ((_ alpha: CGFloat) -> Void)?
    
    init(delegate: LFSSquareCaptureViewModelDelegate) {
        super.init()
        self.delegate = delegate
        camera = Camera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(flip), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flash), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(snapSquare), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapSquare), object: nil)
    }
    
    internal func startSquareCapture() {
        camera.prepare(completion: { [weak self] () -> Void in
            try? self?.camera.displayPreview()
            self?.camera.addPreviewLayer(view: (self?.squareView)!)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    internal func begin() {
        if camera.initialed {
            startSquareCapture()
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
extension LFSSquareCaptureViewModel {
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
    
    @objc private func snapSquare() {
        camera.captureImage(completion: { [weak self] (image) -> Void in
            self?.image = image
            self?.delegate?.didReceivedImage()
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}

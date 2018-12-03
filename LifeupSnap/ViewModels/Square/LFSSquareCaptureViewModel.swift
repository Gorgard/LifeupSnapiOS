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
    
    private var image: UIImage?
    
    init(delegate: LFSSquareCaptureViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(flip), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flash), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(snapSquare), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapSquare), object: nil)
    }
    
    internal func startSquareCapture() {
        Camera.shared.prepare(completion: { [weak self] () -> Void in
            try? Camera.shared.displayPreview()
            Camera.shared.addPreviewLayer(view: (self?.view)!)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}

//MARK: Handle Notification
extension LFSSquareCaptureViewModel {
    @objc private func flip() {
        try? Camera.shared.switchCamera()
    }
    
    @objc private func flash() {
        if Camera.shared.flashMode == .on {
            Camera.shared.flashMode = .off
        }
        else {
            Camera.shared.flashMode = .on
        }
    }
    
    @objc private func snapSquare() {
        Camera.shared.captureImage(completion: { [weak self] (image) -> Void in
            self?.image = image
            self?.delegate?.didReceivedImage()
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}

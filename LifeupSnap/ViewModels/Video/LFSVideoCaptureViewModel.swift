//
//  LFSVideoCaptureViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 3/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSVideoCaptureViewModel: LFSViewModel {
    private weak var delegate: LFSVideoCaptureViewModelDelegate?
    
    private var camera: Camera!
    
    init(delegate: LFSVideoCaptureViewModelDelegate) {
        super.init()
        self.delegate = delegate
        camera = Camera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(flip), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flash), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(snapVideo), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapVideo), object: nil)
    }
    
    internal func startVideoCapture() {
        camera.prepare(completion: { [weak self] () -> Void in
            try? self?.camera.displayPreview()
            self?.camera.addPreviewLayer(view: (self?.videoView)!)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    internal func begin() {
        if camera.initialed {
            camera.begin()
        }
    }
}

//MARK: Handle Notification
extension LFSVideoCaptureViewModel {
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
    
    @objc private func snapVideo() {
        if camera.isRecording {
            stopRecord()
            return
        }
        
        record()
    }
    
    private func record() {
        camera.recordVideo(completion: { [weak self] (data) -> Void in
            print(data)
            }, failure: { (error) -> Void in
                print(error?.localizedDescription ?? "")
        })
    }
    
    private func stopRecord() {
        camera.stopRecord()
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.finishedSnapVideo), object: nil)
    }
}

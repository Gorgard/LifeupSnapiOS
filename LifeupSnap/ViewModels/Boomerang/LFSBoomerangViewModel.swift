//
//  LFSBoomerangViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 6/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSBoomerangViewModel: LFSViewModel {
    private weak var delegate: LFSBoomerangViewModelDelegate?
    
    private var camera: Camera!
    
    init(delegate: LFSBoomerangViewModelDelegate) {
        super.init()
        self.delegate = delegate
        camera = Camera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(flip), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flipCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flash), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.flashCamera), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(snapBoomerang), name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.snapBoomerang), object: nil)
    }
    
    internal func startBoomerang() {
        camera.prepare(completion: { [weak self] () -> Void in
            try? self?.camera.displayPreview()
            self?.camera.addPreviewLayer(view: (self?.boomerangView)!)
        }, failure: { (error) -> Void in
            
        })
    }
    
    internal func begin() {
        if camera.initialed {
            camera.begin()
        }
    }
}

//MARK: Handle Notification
extension LFSBoomerangViewModel {
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
    
    @objc private func snapBoomerang() {
        if camera.isRecording {
            stopRecord()
            return
        }
        
        record()
    }
    
    private func record() {
        camera.maxDuration = 10
        camera.recordVideo(completion: { [weak self] (data) -> Void in
            self?.handleRecord()
            }, failure: { (error) -> Void in
                print(error?.localizedDescription ?? "")
        })
    }
    
    private func handleRecord() {
        if camera.selfStop {
            NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.finishedSnapBoomerang), object: nil)
        }
    }
    
    private func stopRecord() {
        camera.stopRecord()
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFSConstants.LFSNotificationID.Snap.finishedSnapBoomerang), object: nil)
    }
}

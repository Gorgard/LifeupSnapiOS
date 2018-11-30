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
    
    init(delegate: LFSSquareCaptureViewModelDelegate) {
        self.delegate = delegate
        camera = Camera()
    }
    
    internal func startSquareCapture() {
        camera.prepare(completion: { [weak self] () -> Void in
            try? self?.camera.displayPreview()
            self?.camera.addPreviewLayer(view: (self?.view)!)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}

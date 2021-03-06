//
//  LFSPhotoPreviewViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 12/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSPhotoPreviewViewModel: LFSViewModel {
    private weak var delegate: LFSPhotoPreviewViewModelDelegate?
    
    internal var image: UIImage?
    
    init(delegate: LFSPhotoPreviewViewModelDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        removeAll()
    }
}

//MARK: Handle Action
extension LFSPhotoPreviewViewModel {
    internal func next() {
        let lfsEditViewController = LFSEditViewController()
        lfsEditViewController.image = image
        lfsEditViewController.editEvent = .photo
        
        viewController?.present(lfsEditViewController, animated: true, completion: nil)
    }
}

//MARK: Remove all
extension LFSPhotoPreviewViewModel {
    fileprivate func removeAll() {
        delegate = nil
        image = nil
    }
}

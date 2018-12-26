//
//  LFSPhotoEditedPreviewViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 26/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSPhotoEditedPreviewViewModel: LFSViewModel {
    private weak var delegate: LFSPhotoEditedPreviewViewModelDelegate?
    
    internal var image: UIImage?
    
    init(delegate: LFSPhotoEditedPreviewViewModelDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        removeAll()
    }
}

//MARK: Handle Action
extension LFSPhotoEditedPreviewViewModel {
    internal func next() {
//        let lfsEditViewController = LFSEditViewController()
//        lfsEditViewController.image = image
//        lfsEditViewController.editEvent = .photo
//
//        viewController?.present(lfsEditViewController, animated: true, completion: nil)
    }
    
    internal func save() {
        guard let image = image else { return }
        
        LFSPhotoModel.shared.savePhotoToAlbum(image: image, completion: { () -> Void in
            
        }, failure: { (error) -> Void in
            
        })
    }
}

//MARK: Remove all
extension LFSPhotoEditedPreviewViewModel {
    fileprivate func removeAll() {
        delegate = nil
        image = nil
    }
}


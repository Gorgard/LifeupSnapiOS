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
        
        LFSPhotoModel.shared.savePhotoToAlbum(image: image, completion: { [unowned self] () -> Void in
            self.handleSaveSuccess()
        }, failure: { [unowned self] (error) -> Void in
            self.handleSaveFailure()
        })
    }
    
    internal func handleSaveSuccess() {
        let alertController = AlertController(title: LFSConstants.LFSAlertWording.saved, message: LFSConstants.LFSAlertWording.photoSaved, acceptButtonTitle: LFSConstants.LFSAlertWording.ok, cancelButtonTitle: nil)
        alertController.shouldHaveCancelButton = false
        
        alertController.show(viewController: viewController!, accept: { (alert) -> Void in
            super.closeToRoot()
        }, cancel: nil)
    }
    
    internal func handleSaveFailure() {
        let alertController = AlertController(title: LFSConstants.LFSAlertWording.saveFailure, message: LFSConstants.LFSAlertWording.areYouResave, acceptButtonTitle: LFSConstants.LFSAlertWording.resave, cancelButtonTitle: LFSConstants.LFSAlertWording.cancel)
        
        alertController.show(viewController: viewController!, accept: { [unowned self] (alert) -> Void in
            self.save()
        }, cancel: { (alert) -> Void in
            super.closeToRoot()
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


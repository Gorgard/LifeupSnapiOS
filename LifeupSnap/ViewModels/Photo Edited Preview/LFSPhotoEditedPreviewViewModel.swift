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
    internal weak var baseDelegate: LFSSnapDelegate?
    
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
        delegate?.pressedNext()
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
        let alertController = AlertController(title: LFSConstants.LFSWording.saved,
                                              message: LFSConstants.LFSWording.photoSaved,
                                              acceptButtonTitle: LFSConstants.LFSWording.ok,
                                              cancelButtonTitle: nil)
        
        alertController.shouldHaveCancelButton = false
        
        alertController.show(viewController: viewController!, accept: { (alert) -> Void in
            self.delegate?.photoSaved()
        }, cancel: nil)
    }
    
    internal func handleSaveFailure() {
        let alertController = AlertController(title: LFSConstants.LFSWording.saveFailure,
                                              message: LFSConstants.LFSWording.areYouResave,
                                              acceptButtonTitle: LFSConstants.LFSWording.resave,
                                              cancelButtonTitle: LFSConstants.LFSWording.cancel)
        
        alertController.show(viewController: viewController!, accept: { [unowned self] (alert) -> Void in
            self.save()
        }, cancel: { (alert) -> Void in
            self.delegate?.photoSaved()
        })
    }
}

//MARK: Handle Self Protocol
extension LFSPhotoEditedPreviewViewModel {
    internal func photoSaved() {
        if let image = image {
            baseDelegate?.snapPhoto?(whenSaved: image)
        }
        
        super.closeToRoot()
    }
    
    internal func pressedNext() {
        if let image = image {
            baseDelegate?.snapPhoto?(whenNextAfterEdited: image)
        }
        
        super.closeToRoot()
    }
}

//MARK: Remove all
extension LFSPhotoEditedPreviewViewModel {
    fileprivate func removeAll() {
        delegate = nil
        image = nil
    }
}


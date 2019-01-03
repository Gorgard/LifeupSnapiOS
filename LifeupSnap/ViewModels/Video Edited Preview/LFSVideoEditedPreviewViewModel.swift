//
//  LFSVideoEditedPreviewViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 26/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation

internal class LFSVideoEditedPreviewViewModel: LFSViewModel {
    private weak var delegate: LFSVideoEditedPreviewViewModelDelegate?
    internal weak var baseDelegate: LFSSnapDelegate?
    
    internal var url: URL?
    
    internal var player: AVPlayer!
    internal var playerLayer: AVPlayerLayer!
    
    private var savedURL: AVURLAsset?
    
    init(delegate: LFSVideoEditedPreviewViewModelDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        removeAll()
    }
}

extension LFSVideoEditedPreviewViewModel {
    private func setup() {
        if let url = url {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            
            view?.layer.addSublayer(playerLayer)
        }
    }
    
    internal func setupLayer() {
        if let view = view {
            playerLayer.frame = view.bounds
        }
    }
}

//MARK: Handle Media
extension LFSVideoEditedPreviewViewModel {
    internal func preview() {
        setup()
        play()
    }
    
    internal func replay() {
        player.seek(to: kCMTimeZero)
        
        play()
    }
    
    private func play() {
        player.play()
    }
    
    internal func next() {
        delegate?.pressedNext()
    }
    
    internal func save() {
        guard let url = url else { return }
        
        LFSVideoModel.shared.saveVideoByURL(url: url, completion: { [unowned self] (savedURL) -> Void in
            self.savedURL = savedURL
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
            self.delegate?.videoSaved()
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
            self.delegate?.videoSaved()
        })
    }
}

//MARK: Handle Self Protocol
extension LFSVideoEditedPreviewViewModel {
    internal func videoSaved() {
        if let savedURL = savedURL {
            baseDelegate?.snapVideo?(whenSaved: savedURL.url)
        }
        
        super.closeToRoot()
    }
    
    internal func pressedNext() {
        if let url = url {
            baseDelegate?.snapVideo?(whenNextAfterEdited: url)
        }
        
        super.closeToRoot()
    }
}

//MARK: Remove all
extension LFSVideoEditedPreviewViewModel {
    fileprivate func removeAll() {
        delegate = nil
        url = nil
        player = nil
        playerLayer = nil
    }
}

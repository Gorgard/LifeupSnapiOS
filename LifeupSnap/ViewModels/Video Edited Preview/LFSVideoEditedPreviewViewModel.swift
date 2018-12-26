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
    
    internal var url: URL?
    
    internal var player: AVPlayer!
    internal var playerLayer: AVPlayerLayer!
    
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
//        let lfsEditViewController = LFSEditViewController()
//        lfsEditViewController.url = url
//        lfsEditViewController.editEvent = .video
//
//        viewController?.present(lfsEditViewController, animated: true, completion: nil)
    }
    
    internal func save() {
        guard let url = url else { return }
        
        LFSVideoModel.shared.saveVideoByURL(url: url, completion: { (savedURL) -> Void in
            
        }, failure: { (error) -> Void in
            
        })
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

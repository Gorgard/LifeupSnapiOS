//
//  LFSVideoPreviewViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 11/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation

internal class LFSVideoPreviewViewModel: LFSViewModel {
    private weak var delegate: LFSVideoPreviewViewModelDelegate?
    
    internal var url: URL?
    
    internal var player: AVPlayer!
    internal var playerLayer: AVPlayerLayer!
    
    init(delegate: LFSVideoPreviewViewModelDelegate) {
        self.delegate = delegate
    }
    
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
}

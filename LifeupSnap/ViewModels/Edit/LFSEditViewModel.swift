//
//  LFSEditViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditViewModel: LFSViewModel {
    private weak var delegate: LFSEditViewModelDelegate?
    
    internal var editEvent: EditEvent!
    
    internal var image: UIImage?
    internal var url: URL?
    
    internal var receivedThumbnailImage: ((_ image: UIImage?) -> Void)?
    
    init(delegate: LFSEditViewModelDelegate) {
        self.delegate = delegate
    }
}

//MARK: Base
extension LFSEditViewModel {
    internal func binding() {
        switch editEvent {
        case .photo:
            thumbnailPhoto()
            break
        case .video:
            thumbnailVideo()
            break
        default:
            break
        }
    }
}

//MARK: Thumbnail
extension LFSEditViewModel {
    private func thumbnailVideo() {
        if let url = url {
            let thumbnailImage = LFSVideoModel.shared.thumnailImage(from: url)
            
            receivedThumbnailImage?(thumbnailImage)
        }
    }
    
    private func thumbnailPhoto() {
        receivedThumbnailImage?(image)
    }
}

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
}

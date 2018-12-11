//
//  LFSVideoPreviewViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 11/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSVideoPreviewViewModel: LFSViewModel {
    private weak var delegate: LFSVideoPreviewViewModelDelegate?
    
    internal var url: URL?
    
    init(delegate: LFSVideoPreviewViewModelDelegate) {
        self.delegate = delegate
    }
}

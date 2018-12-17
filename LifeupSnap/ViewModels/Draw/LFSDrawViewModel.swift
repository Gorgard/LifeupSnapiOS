//
//  LFSDrawViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 17/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSDrawViewModel: LFSViewModel {
    private weak var delegate: LFSDrawViewModelDelegate?
    
    init(delegate: LFSDrawViewModelDelegate) {
        self.delegate = delegate
    }
}

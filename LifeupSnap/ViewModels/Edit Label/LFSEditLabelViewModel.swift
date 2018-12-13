//
//  LFSEditLabelViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditLabelViewModel: LFSViewModel {
    private weak var delegate: LFSEditLabelViewModelDelegate?
    
    internal var label: UILabel!
    
    init(delegate: LFSEditLabelViewModelDelegate) {
        self.delegate = delegate
    }
}

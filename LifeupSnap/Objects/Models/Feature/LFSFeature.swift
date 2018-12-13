//
//  LFSFeature.swift
//  LifeupSnap
//
//  Created by lifeup on 29/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal struct LFSFeature {
    var name: String
    var isCurrent: Bool
    
    init(name: String, isCurrent: Bool) {
        self.name = name
        self.isCurrent = isCurrent
    }
}

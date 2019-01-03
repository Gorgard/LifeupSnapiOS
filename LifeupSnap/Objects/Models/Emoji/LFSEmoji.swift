//
//  LFSEmoji.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal struct LFSEmoji {
    var name: String
    var section: String
    var value: Any
    
    internal init(name: String, section: String, value: Any) {
        self.name = name
        self.section = section
        self.value = value
    }
}
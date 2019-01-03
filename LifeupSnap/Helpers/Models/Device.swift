//
//  Device.swift
//  LifeupSnap
//
//  Created by lifeup on 3/1/2562 BE.
//  Copyright © 2562 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

extension UIDevice {
    var isSimulator: Bool {
        #if IOS_SIMULATOR
            return true
        #else
            return false
        #endif
    }
}

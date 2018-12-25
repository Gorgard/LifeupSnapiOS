//
//  LFSGraphDecoder.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal protocol LFSGraphDecoder {
    init(json: [String: Any])
    func toJson() -> [String: Any]?
}

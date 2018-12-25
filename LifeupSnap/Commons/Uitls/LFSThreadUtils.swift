//
//  LFSThreadUtils.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal func taskQOS(qos: DispatchQoS.QoSClass, _ block: @escaping() -> Void) {
    let queue = DispatchQueue.global(qos: qos)
    
    queue.async {
        block()
    }
}

internal func taskMain(_ block: @escaping() -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

internal func taskBackground(label: String, _ block: @escaping() -> Void) {
    DispatchQueue(label: label).async {
        block()
    }
}

internal func taskMainAfter(deadline: DispatchTime, _ block: @escaping() -> Void) {
    DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
        block()
    })
}

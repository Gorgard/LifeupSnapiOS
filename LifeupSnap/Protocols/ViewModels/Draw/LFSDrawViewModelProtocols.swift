//
//  LFSDrawViewModelProtocols.swift
//  LifeupSnap
//
//  Created by lifeup on 17/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal protocol LFSDrawViewModelDelegate: class {
    func tappedDoneButton()
    func choosedColor()
}

internal protocol LFSDrawDelegate: class, NSObjectProtocol {
    func draw(received drawView: DrawView)
    func didDrawed()
}

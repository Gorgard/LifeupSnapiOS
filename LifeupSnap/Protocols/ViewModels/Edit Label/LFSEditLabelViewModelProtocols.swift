//
//  LFSEditLabelViewModelProtocols.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal protocol LFSEditLabelViewModelDelegate: class {
    func tappedDoneButton()
}

internal protocol LFSEditLabelDelegate: class, NSObjectProtocol {
    func editLabel(recieved dragTextView: DragTextView)
    func editedLabel()
}

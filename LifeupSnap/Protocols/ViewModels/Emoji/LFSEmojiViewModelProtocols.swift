//
//  LFSEmojiViewModelProtocols.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal protocol LFSEmojiViewModelDelegate: class {
    func dismissedView()
}

internal protocol LFSEmojiDelegate: class, NSObjectProtocol {
    func emoji(recieved emojiView: EmojiView)
    func dismissedView()
}

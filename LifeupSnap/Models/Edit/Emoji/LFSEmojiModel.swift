//
//  LFSEmojiModel.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEmojiModel: LFSEditModel {
    //MARK: Emoji System
    private let kEmojiSystemCount: Int = 2347
    private let kEmojiSystemIncreaseRange: Int = 200
    private var emojiSystemStartRange: Int = 1
    private var emojiSystemChangeRage: Int = 60
    
    //MARK: Emoji Self
    private let kEmojiSelfCount: Int = 75
    private let emojiSelfStartRange: Int = 1
    
    //MARK: Commons
    internal let kImageWidth: CGFloat = 50
    
    internal func loadMoreEmojiSystems() -> [LFSEmoji] {
        var emojiSystems = [LFSEmoji]()
        
        if emojiSystemStartRange <= kEmojiSystemCount {
            for i in emojiSystemStartRange...emojiSystemChangeRage {
                if i <= kEmojiSystemCount {
                    let emoji = LFSEmoji(name: "emo_system_\(i)", section: LFSConstants.LFSEmoji.kEmojiSystemSection, value: LFSConstants.LFSEmojiPath.emojiSystem + "emo_system_\(i).png")
                    emojiSystems.append(emoji)
                }
            }
            
            emojiSystemStartRange = emojiSystemChangeRage
            emojiSystemChangeRage += kEmojiSystemIncreaseRange
        }
        
        return emojiSystems
    }
    
    internal func loadMoreEmojiSelfs() -> [LFSEmoji] {
        var emojiSelfs = [LFSEmoji]()
        
        for i in emojiSelfStartRange...kEmojiSelfCount {
            if let image = LFSPhotoModel.shared.imageBundle(named: "Emo\(i)", fromClass: LFSEmojiModel.self)?.resizeWithWidth(width: kImageWidth) {
                let emoji = LFSEmoji(name: "emoji_self_\(i)", section: LFSConstants.LFSEmoji.kEmojiSelfSection, value: image)
                
                emojiSelfs.append(emoji)
            }
        }
        
        return emojiSelfs
    }
}

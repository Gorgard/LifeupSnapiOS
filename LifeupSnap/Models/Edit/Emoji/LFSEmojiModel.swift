//
//  LFSEmojiModel.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEmojiModel: LFSEditModel {
    private let emojiSystemCount: Int = 2347
    
    private var emojiCurrentRange: Int = 1
    private var emojiChangeRage: Int = 60
    
    private var loadedEmojiSelf: Bool = false
    
    internal func loadMoreEmojiSystems() -> [LFSEmoji] {
        var emojiSystems = [LFSEmoji]()
        
        if emojiCurrentRange <= emojiSystemCount {
            for i in emojiCurrentRange...emojiChangeRage {
                if i <= emojiSystemCount {
                    let emoji = LFSEmoji(name: "emo_system_\(i)", section: LFSConstants.LFSEmoji.emojiSystemSection, value: LFSConstants.LFSEmojiPath.emojiSystem + "emo_system_\(i).png")
                    emojiSystems.append(emoji)
                }
            }
            
            emojiCurrentRange = emojiChangeRage
            emojiChangeRage += 200
        }
        
        return emojiSystems
    }
    
    internal func loadMoreEmojiSelfs() -> [LFSEmoji] {
        var emojiSelfs = [LFSEmoji]()
        
        for i in 1...75 {
            if let image = LFSPhotoModel.shared.imageBundle(named: "Emo\(i)", fromClass: LFSEmojiModel.self)?.resizeWithWidth(width: 50) {
                let emoji = LFSEmoji(name: "EmojiSelf\(i)", section: LFSConstants.LFSEmoji.emojiSelfSection, value: image)
                
                emojiSelfs.append(emoji)
            }
        }
        
        return emojiSelfs
    }
}

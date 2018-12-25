//
//  LFSEditModel.swift
//  LifeupSnap
//
//  Created by lifeup on 14/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation

internal class LFSEditModel: LFSBaseModel {
    internal static let shared: LFSEditModel = LFSEditModel()
    
    internal func filterEmojisInEachSection(emojis: [LFSEmoji], section: String) -> [LFSEmoji] {
        let _emojis = emojis.filter({ $0.section == section })
        return _emojis
    }
    
    internal func getEmojiSections() -> [String] {
        let sections = [LFSConstants.LFSEmoji.emojiSelfSection, LFSConstants.LFSEmoji.emojiSystemSection, LFSConstants.LFSEmoji.emojiCustomSection]
        return sections
    }
    
    internal func renderImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image(actions: { (rendererContext) in
            view.layer.render(in: rendererContext.cgContext)
        })
        
        return image
    }
}

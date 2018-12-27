//
//  LFSEmojiSelfCollectionViewCell.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEmojiSelfCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var emojiImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    deinit {
        emojiImageView = nil
    }
}

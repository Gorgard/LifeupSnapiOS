//
//  LFSEmojiCollectionViewCell.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSEmojiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var emojiView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    internal func makeLabel(value: Any) {
        let text = value as! String
        
        let label = UILabel(frame: emojiView.bounds)
        label.text = text
        
        emojiView.addSubview(label)
    }
    
    internal func makeImage(value: Any) {
        let image = value as! UIImage
        
        let imageView = UIImageView(frame: emojiView.bounds)
        imageView.image = image
        
        emojiView.addSubview(imageView)
    }
}

//
//  LFSLabelColorCollectionViewCell.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSLabelColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverLabelColorView: UIView!
    @IBOutlet weak var labelColorView: UIView!
    @IBOutlet weak var choosedColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    deinit {
        coverLabelColorView = nil
        labelColorView = nil
        choosedColorView = nil
    }

    fileprivate func setup() {
        coverLabelColorView.layer.cornerRadius = coverLabelColorView.bounds.size.height / 2
        labelColorView.layer.cornerRadius = labelColorView.bounds.size.height / 2
        choosedColorView.layer.cornerRadius = choosedColorView.bounds.size.height / 2
    }
}

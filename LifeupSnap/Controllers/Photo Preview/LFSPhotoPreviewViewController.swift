//
//  LFSPhotoPreviewViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 12/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSPhotoPreviewViewController: UIViewController {
    @IBOutlet weak var previewImageView: UIImageView!
    
    internal var viewModel: LFSPhotoPreviewViewModel!
    
    internal var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Setups
extension LFSPhotoPreviewViewController {
    fileprivate func setup() {
        viewModel = LFSPhotoPreviewViewModel(delegate: self)
        viewModel.image = image
        viewModel.viewController = self
    }
}

//MARK: LFSPhotoPreviewViewModelDelegate
extension LFSPhotoPreviewViewController: LFSPhotoPreviewViewModelDelegate {
    
}

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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    internal var viewModel: LFSPhotoPreviewViewModel!
    
    internal var image: UIImage?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init() {
        let bundle = Bundle(for: LFSPhotoPreviewViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsPhotoPreviewController, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        viewModel.close()
    }
    
    @IBAction func onTappedNext(_ sender: Any) {
        viewModel.next()
    }
}

//MARK: Setups
extension LFSPhotoPreviewViewController {
    fileprivate func setup() {
        viewModel = LFSPhotoPreviewViewModel(delegate: self)
        viewModel.image = image
        viewModel.viewController = self
    }
    
    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = nextButton.bounds.size.height / 2
        nextButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 0
        
        previewImageView.image = image
    }
}

//MARK: LFSPhotoPreviewViewModelDelegate
extension LFSPhotoPreviewViewController: LFSPhotoPreviewViewModelDelegate {
    
}

//MARK: Orientation
extension LFSPhotoPreviewViewController {
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

//MARK: Remove all
extension LFSPhotoPreviewViewController {
    fileprivate func removeAll() {
        previewImageView = nil
        nextButton = nil
        backButton = nil
    }
}

//
//  LFSPhotoEditedPreviewViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 26/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSPhotoEditedPreviewViewController: UIViewController {
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    internal weak var baseDelegate: LFSSnapDelegate?
    
    internal var viewModel: LFSPhotoEditedPreviewViewModel!
    
    internal var image: UIImage?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init() {
        let bundle = Bundle(for: LFSPhotoEditedPreviewViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Edited.lfsPhotoEditedPreviewViewController, bundle: bundle)
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
        binding()
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
    
    @IBAction func onTappedSave(_ sender: Any) {
        viewModel.save()
    }
}

//MARK: Setups
extension LFSPhotoEditedPreviewViewController {
    fileprivate func setup() {
        viewModel = LFSPhotoEditedPreviewViewModel(delegate: self)
        viewModel.image = image
        viewModel.baseDelegate = baseDelegate
        viewModel.viewController = self
        viewModel.view = view
    }
    
    fileprivate func binding() {
        
    }
    
    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = nextButton.bounds.size.height / 2
        nextButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 0
        
        backButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowOpacity = 1
        backButton.layer.shadowRadius = 0
        
        saveButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowOpacity = 1
        saveButton.layer.shadowRadius = 0
        
        previewImageView.image = image
    }
}

//MARK: LFSPhotoEditedPreviewViewModelDelegate
extension LFSPhotoEditedPreviewViewController: LFSPhotoEditedPreviewViewModelDelegate {
    internal func photoSaved() {
        viewModel.photoSaved()
    }
    
    internal func pressedNext() {
        viewModel.pressedNext()
    }
}

//MARK: Orientation
extension LFSPhotoEditedPreviewViewController {
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
extension LFSPhotoEditedPreviewViewController {
    fileprivate func removeAll() {
        previewImageView = nil
        nextButton = nil
        saveButton = nil
        backButton = nil
    }
}

//
//  LFSVideoEditedPreviewViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 26/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSVideoEditedPreviewViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    internal weak var baseDelegate: LFSSnapDelegate?
    
    internal var viewModel: LFSVideoEditedPreviewViewModel!
    
    internal var url: URL?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init() {
        let bundle = Bundle(for: LFSVideoEditedPreviewViewController.self)
        super.init(nibName: kLfsVideoEditedPreviewViewController, bundle: bundle)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.setupLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        viewModel.close()
    }
    
    @IBAction func onTappedReplay(_ sender: Any) {
        viewModel.replay()
    }
    
    @IBAction func onTappedNext(_ sender: Any) {
        viewModel.next()
    }
    
    @IBAction func onTappedSave(_ sender: Any) {
        viewModel.save()
    }
}

//MARK: Setups
extension LFSVideoEditedPreviewViewController {
    fileprivate func setup() {
        viewModel = LFSVideoEditedPreviewViewModel(delegate: self)
        viewModel.url = url
        viewModel.baseDelegate = baseDelegate
        viewModel.viewController = self
        viewModel.view = videoView
        
        viewModel.preview()
    }
    
    fileprivate func binding() {
        
    }
    
    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = nextButton.bounds.size.height / 2
        nextButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 0
        
        replayButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        replayButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        replayButton.layer.shadowOpacity = 1
        replayButton.layer.shadowRadius = 0
        
        backButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowOpacity = 1
        backButton.layer.shadowRadius = 0
        
        saveButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowOpacity = 1
        saveButton.layer.shadowRadius = 0
    }
}

//MARK: LFSVideoEditedPreviewViewModelDelegate
extension LFSVideoEditedPreviewViewController: LFSVideoEditedPreviewViewModelDelegate {
    internal func videoSaved() {
        viewModel.videoSaved()
    }
    
    internal func pressedNext() {
        viewModel.pressedNext()
    }
}

//MARK: Orientation
extension LFSVideoEditedPreviewViewController {
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
extension LFSVideoEditedPreviewViewController {
    fileprivate func removeAll() {
        videoView = nil
        backButton = nil
        replayButton = nil
        nextButton = nil
        saveButton = nil
        viewModel = nil
    }
}

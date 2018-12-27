//
//  LFSVideoPreviewViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 11/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSVideoPreviewViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    internal var viewModel: LFSVideoPreviewViewModel!
    
    internal var url: URL?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init() {
        let bundle = Bundle(for: LFSVideoPreviewViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsVideoPreviewController, bundle: bundle)
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
}

//MARK: Setups
extension LFSVideoPreviewViewController {
    fileprivate func setup() {
        viewModel = LFSVideoPreviewViewModel(delegate: self)
        viewModel.url = url
        viewModel.viewController = self
        viewModel.view = videoView
        
        viewModel.preview()
    }
    
    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = nextButton.bounds.size.height / 2
        nextButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 0
    }
}

//MARK: LFSVideoPreviewViewModelDelegate
extension LFSVideoPreviewViewController: LFSVideoPreviewViewModelDelegate {
    
}

//MARK: Orientation
extension LFSVideoPreviewViewController {
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
extension LFSVideoPreviewViewController {
    fileprivate func removeAll() {
        videoView = nil
        backButton = nil
        replayButton = nil
        nextButton = nil
        viewModel = nil
        url = nil
    }
}

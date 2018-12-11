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
    
    internal init() {
        let bundle = Bundle(for: LFSVideoPreviewViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsVideoPreviewController, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTappedBack(_ sender: Any) {
        
    }
    
    @IBAction func onTappedReplay(_ sender: Any) {
        
    }
    
    @IBAction func onTappedNext(_ sender: Any) {
        
    }
}

//MARK: Setups
extension LFSVideoPreviewViewController {
    fileprivate func setup() {
        viewModel = LFSVideoPreviewViewModel(delegate: self)
        viewModel.url = url
        viewModel.navigationController = LFSSnapViewController.baseNavigation
    }
    
    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = 8
    }
}

//MARK: LFSVideoPreviewViewModelDelegate
extension LFSVideoPreviewViewController: LFSVideoPreviewViewModelDelegate {
    
}

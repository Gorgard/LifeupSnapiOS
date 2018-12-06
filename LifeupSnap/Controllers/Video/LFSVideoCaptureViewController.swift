//
//  LFSVideoCaptureViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSVideoCaptureViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    
    internal var viewModel: LFSVideoCaptureViewModel!
    
    public init() {
        let bundle = Bundle(for: LFSVideoCaptureViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsVideoCaptureViewController, bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.begin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.startVideoCapture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Setups
extension LFSVideoCaptureViewController {
    fileprivate func setup() {
        viewModel = LFSVideoCaptureViewModel(delegate: self)
        viewModel.videoView = videoView
    }
}

//MARK: LFSVideoCaptureViewModelDelegate
extension LFSVideoCaptureViewController: LFSVideoCaptureViewModelDelegate {
    func didReceivedVideo() {
        
    }
}

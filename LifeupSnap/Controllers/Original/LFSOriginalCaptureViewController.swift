//
//  LFSOriginalCaptureViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSOriginalCaptureViewController: UIViewController {
    @IBOutlet weak var originalView: UIView!
    
    internal var viewModel: LFSOriginalCaptureViewModel?
    
    public init() {
        let bundle = Bundle(for: LFSOriginalCaptureViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsOriginalCaptureViewController, bundle: bundle)
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
        viewModel?.begin()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel?.startOriginalCapture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Setups
extension LFSOriginalCaptureViewController {
    fileprivate func setup() {
        viewModel = LFSOriginalCaptureViewModel(delegate: self)
        viewModel?.originalView = originalView
    }
}

//MARK: LFSOriginalCaptureViewModelDelegate
extension LFSOriginalCaptureViewController: LFSOriginalCaptureViewModelDelegate {
    func didReceivedImage() {
        
    }
}

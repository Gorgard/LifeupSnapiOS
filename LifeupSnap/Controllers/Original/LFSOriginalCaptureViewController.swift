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
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    internal var viewModel: LFSOriginalCaptureViewModel!
    
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
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.begin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisappear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.startOriginalCapture()
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
        viewModel.originalView = originalView
    }
    
    fileprivate func binding() {
        viewModel.hiddenBlurView = { [unowned self] (alpha) -> Void in
            UIView.animate(withDuration: 0.1, animations: {
                self.blurView.alpha = alpha
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.binding()
    }
}

//MARK: LFSOriginalCaptureViewModelDelegate
extension LFSOriginalCaptureViewController: LFSOriginalCaptureViewModelDelegate {
    func didReceivedImage() {
        
    }
}

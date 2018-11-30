//
//  LFSSquareCaptureViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSSquareCaptureViewController: UIViewController {
    @IBOutlet weak var squareView: UIView!
    
    internal var viewModel: LFSSquareCaptureViewModel?
    
    init() {
        let bundle = Bundle(for: LFSSquareCaptureViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsSquareCaptureViewController, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        viewModel?.startSquareCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Setups
extension LFSSquareCaptureViewController {
    fileprivate func setup() {
        viewModel = LFSSquareCaptureViewModel(delegate: self)
        viewModel?.view = squareView
    }
}

//MARK: LFSSquareCaptureViewModelDelegate
extension LFSSquareCaptureViewController: LFSSquareCaptureViewModelDelegate {
    
}

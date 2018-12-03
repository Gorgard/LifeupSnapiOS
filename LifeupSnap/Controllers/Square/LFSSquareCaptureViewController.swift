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
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    internal var viewModel: LFSSquareCaptureViewModel!
    
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
        viewModel.startSquareCapture()
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
        viewModel.squareView = squareView
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

//MARK: LFSSquareCaptureViewModelDelegate
extension LFSSquareCaptureViewController: LFSSquareCaptureViewModelDelegate {
    func didReceivedImage() {
        
    }
}

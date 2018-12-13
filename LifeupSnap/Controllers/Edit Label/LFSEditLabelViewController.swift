//
//  LFSEditLabelViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditLabelViewController: UIViewController {
    private weak var delegate: LFSEditLabelDelegate?
    
    internal var viewModel: LFSEditLabelViewModel!

    internal var label: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init(delegate: LFSEditLabelDelegate) {
        let bundle = Bundle(for: LFSEditLabelViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Edit.lfsEditLabelViewController, bundle: bundle)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
}

//MARK: Setups
extension LFSEditLabelViewController {
    fileprivate func setup() {
        viewModel = LFSEditLabelViewModel(delegate: self)
        viewModel.label = label
        viewModel.viewController = self
    }
    
    fileprivate func setupViews() {
        
    }
}

//MARK: LFSEditLabelViewModelDelegate
extension LFSEditLabelViewController: LFSEditLabelViewModelDelegate {
    
}

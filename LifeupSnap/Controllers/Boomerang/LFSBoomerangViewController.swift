//
//  LFSBoomerangViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSBoomerangViewController: UIViewController {
    @IBOutlet weak var boomerangView: UIView!
    
    internal var viewModel: LFSBoomerangViewModel!
    
    public init() {
        let bundle = Bundle(for: LFSBoomerangViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsBoomerangViewController, bundle: bundle)
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
        viewModel.startBoomerang()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Setups
extension LFSBoomerangViewController {
    fileprivate func setup() {
        viewModel = LFSBoomerangViewModel(delegate: self)
        viewModel.boomerangView = boomerangView
    }
}

//MARK: LFSBoomerangViewModelDelegate
extension LFSBoomerangViewController: LFSBoomerangViewModelDelegate {
    func didRecievedBoomerang() {
        
    }
}

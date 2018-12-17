//
//  LFSDrawViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 17/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSDrawViewController: UIViewController {
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var colorPallateButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var colorPallateView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private weak var delegate: LFSDrawDelegate?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init(delegate: LFSDrawDelegate) {
        let bundle = Bundle(for: LFSDrawViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Edit.lfsDrawViewController, bundle: bundle)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        binding()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Setups
extension LFSDrawViewController {
    fileprivate func setups() {
        
    }
    
    fileprivate func binding() {
        
    }
    
    fileprivate func setupViews() {
        
    }
}
//MARK: LFSDrawViewModelDelegate
extension LFSDrawViewController: LFSDrawViewModelDelegate {
    
}

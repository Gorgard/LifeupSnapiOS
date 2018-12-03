//
//  LFSOriginalCaptureViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSOriginalCaptureViewController: UIViewController {
    
    public init() {
        let bundle = Bundle(for: LFSOriginalCaptureViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsOriginalCaptureViewController, bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  LFSSnapViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

public class LFSSnapViewController: UIViewController {
    @IBOutlet weak var coverSnapView: UIView!
    @IBOutlet weak var lineInCoverSnapView: UIView!
    @IBOutlet weak var snapView: UIView!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    
    public weak var delegate: LFSSnapDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupViews() {
        coverSnapView.layer.cornerRadius = coverSnapView.bounds.size.height / 2
        lineInCoverSnapView.layer.cornerRadius = lineInCoverSnapView.bounds.size.height / 2
        snapView.layer.cornerRadius = snapView.bounds.size.height / 2
    }
}

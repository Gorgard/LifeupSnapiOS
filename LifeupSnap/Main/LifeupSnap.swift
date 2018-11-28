//
//  LifeupSnap.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

public class LifeupSnap: NSObject {
    public static let shared: LifeupSnap = LifeupSnap()
    
    public weak var delegate: LFSSnapDelegate?
    
    public lazy var viewController: UIViewController = {
        let bundle = Bundle(for: LFSSnapViewController.self)
        let lfsSnapViewController = LFSSnapViewController(nibName: LFSConstants.LFSNibID.Snap.lfsSnapViewController, bundle: bundle)
        lfsSnapViewController.delegate = self.delegate
        
        return lfsSnapViewController
    }()
}

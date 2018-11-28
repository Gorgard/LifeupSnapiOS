//
//  LFSSnapViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

public class LFSSnapViewController: UIViewController {
    @IBOutlet private weak var captureView: UIView!
    @IBOutlet private weak var coverSnapView: UIView!
    @IBOutlet private weak var lineInCoverSnapView: UIView!
    @IBOutlet private weak var snapView: UIView!
    @IBOutlet private weak var snapButton: UIButton!
    @IBOutlet private weak var flipButton: UIButton!
    @IBOutlet private weak var flashButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    private var pageViewController: UIPageViewController!
    private var viewModel: LFSSnapViewModel!
    
    public weak var delegate: LFSSnapDelegate?
    
    public init() {
        let bundle = Bundle(for: LFSSnapViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsSnapViewController, bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViews()
        binding()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIActions
    @IBAction private func onTappedSnap(_ sender: Any) {
        
    }
    
    @IBAction func onTappedFlash(_ sender: Any) {
        
    }
    
    @IBAction func onTappedFlip(_ sender: Any) {
        
    }
    
    @IBAction func onTappedClose(_ sender: Any) {
        
    }
}

//MARK: Setups
extension LFSSnapViewController {
    fileprivate func setup() {
        viewModel = LFSSnapViewModel(delegate: self)
    }
    
    fileprivate func setupViews() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.view.frame = captureView.bounds
        
        addChildViewController(pageViewController)
        captureView.addSubview(pageViewController.view)
        
        coverSnapView.layer.cornerRadius = coverSnapView.bounds.size.height / 2
        lineInCoverSnapView.layer.cornerRadius = lineInCoverSnapView.bounds.size.height / 2
        snapView.layer.cornerRadius = snapView.bounds.size.height / 2
    }
    
    fileprivate func binding() {
        viewModel.receivedFirstPage = { [unowned self] (viewController) -> Void in
            self.pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
        
        viewModel.binding()
    }
}

//MARK: UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension LFSSnapViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewModel.beforeViewController(pageViewController: pageViewController, viewController: viewController)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewModel.afterViewController(pageViewController: pageViewController, viewController: viewController)
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewModel.presentationCount()
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return viewModel.presentationIndex()
    }
}

//MARK: LFSSnapViewModelDelegate
extension LFSSnapViewController: LFSSnapViewModelDelegate {
    
}

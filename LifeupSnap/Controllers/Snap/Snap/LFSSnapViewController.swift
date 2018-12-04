//
//  LFSSnapViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

public class LFSSnapViewController: UIViewController {
    @IBOutlet weak var coverPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var coverSnapView: UIView!
    @IBOutlet weak var lineInCoverSnapView: UIView!
    @IBOutlet weak var snapView: UIView!
    @IBOutlet weak var recordSnapView: UIView!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    //MARK: Constraint
    @IBOutlet weak var pickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewWidthConstraint: NSLayoutConstraint!
    
    open var pageViewController: UIPageViewController!
    open var swipeRightGesture: UISwipeGestureRecognizer!
    open var swipeLeftGesture: UISwipeGestureRecognizer!
    
    internal var viewModel: LFSSnapViewModel!
    
    open var features: [CameraFeature]!
    
    open weak var delegate: LFSSnapDelegate?
    open weak var navigation: UINavigationController?
    
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
        viewModel.snap()
    }
    
    @IBAction func onTappedFlash(_ sender: Any) {
        viewModel.flash()
    }
    
    @IBAction func onTappedFlip(_ sender: Any) {
        viewModel.flip()
    }
    
    @IBAction func onTappedClose(_ sender: Any) {
        viewModel.close()
    }
}

//MARK: Setups
extension LFSSnapViewController {
    fileprivate func setup() {
        viewModel = LFSSnapViewModel(delegate: self)
        viewModel.features = features
        viewModel.navigationController = navigation
        
        viewModel.setup()
    }
    
    fileprivate func setupViews() {
        coverSnapView.layer.cornerRadius = coverSnapView.bounds.size.height / 2
        lineInCoverSnapView.layer.cornerRadius = lineInCoverSnapView.bounds.size.height / 2
        snapView.layer.cornerRadius = snapView.bounds.size.height / 2
        recordSnapView.layer.cornerRadius = 8
        
        setupPageView()
        setupPickerView()
        setupSwipeRight()
        setupSwipeLeft()
    }
    
    fileprivate func setupPageView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.isPagingEnabled = false
        
        pageViewController.view.frame = captureView.bounds
        
        addChildViewController(pageViewController)
        captureView.addSubview(pageViewController.view)
    }
    
    fileprivate func setupPickerView() {
        pickerView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        pickerView.frame = CGRect(x: 0, y: 0, width: coverPickerView.frame.height, height: coverPickerView.frame.width)
        pickerViewHeightConstraint.constant = coverPickerView.frame.width
        pickerViewWidthConstraint.constant = coverPickerView.frame.height
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    fileprivate func setupSwipeRight() {
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        captureView.addGestureRecognizer(swipeRightGesture)
    }
    
    fileprivate func setupSwipeLeft() {
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftGesture.direction = .left
        captureView.addGestureRecognizer(swipeLeftGesture)
    }
    
    fileprivate func binding() {
        viewModel.receivedFirstPage = { [unowned self] (viewController) -> Void in
            self.pageViewController.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        }
        
        viewModel.receivedFirstFeature = { [unowned self] (index) -> Void in
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
            self.pickerView.reloadAllComponents()
        }
        
        viewModel.enableAllView = { [unowned self] (enable) -> Void in
            self.pickerView.isUserInteractionEnabled = enable
            self.swipeLeftGesture.isEnabled = enable
            self.swipeRightGesture.isEnabled = enable
            self.flipButton.isEnabled = enable
            self.flashButton.isEnabled = enable
            self.closeButton.isEnabled = enable
        }
        
        viewModel.hiddenBlurView = { [unowned self] (alpha) -> Void in
            self.blurView.alpha = alpha
        }
        
        viewModel.changeSnapViewColor = { [unowned self] (color) -> Void in
            self.snapView.backgroundColor = color
            self.recordSnapView.backgroundColor = color
        }
        
        viewModel.hiddenSnapView = { [unowned self] (alpha) -> Void in
            UIView.animate(withDuration: 0.3, animations: {
                self.snapView.alpha = alpha
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.binding()
    }
}


//MARK: UIPickerViewDataSource, UIPickerViewDelegate
extension LFSSnapViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents(pickerView: pickerView)
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent(pickerView: pickerView, component: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 40
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 85
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return viewModel.viewForRow(pickerView: pickerView, row: row, component: component, view: view)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelected(pickerView: pickerView, row: row, component: component)
    }
}

//MARK: Handle SwipeGesture
extension LFSSnapViewController {
    @objc fileprivate func handleSwipeRight() {
        viewModel.handleSwipeRight()
    }
    
    @objc fileprivate func handleSwipeLeft() {
        viewModel.handleSwipeLeft()
    }
}

//MARK: LFSSnapViewModelDelegate
extension LFSSnapViewController: LFSSnapViewModelDelegate {
    
}

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
    @IBOutlet weak var coverCaptureView: UIView!
    @IBOutlet weak var coverSnapView: UIView!
    @IBOutlet weak var lineInCoverSnapView: UIView!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var circularProgress: CircularProgress!
    
    //MARK: Constraint
    @IBOutlet weak var pickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSquareViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSquareViewHeightConstraint: NSLayoutConstraint!
    
    open var swipeCaptureViewRightGesture: UISwipeGestureRecognizer!
    open var swipeCaptureViewLeftGesture: UISwipeGestureRecognizer!
    open var swipeBlurViewRightGesture: UISwipeGestureRecognizer!
    open var swipeBlurViewLeftGesture: UISwipeGestureRecognizer!
    
    internal var viewModel: LFSSnapViewModel!
    
    open var features: [CameraFeature]!
    
    open weak var delegate: LFSSnapDelegate?
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }

    public init() {
        let bundle = Bundle(for: LFSSnapViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Snap.lfsSnapViewController, bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        removeAll()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViews()
        binding()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginCamera()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCamera()
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
        viewModel.viewController = self
        viewModel.view = captureView
        
        viewModel.setup()
    }
    
    fileprivate func setupViews() {
        viewModel.coverCaptureViewBounds = coverCaptureView.bounds
        viewModel.circularProgress = circularProgress
        viewModel.snapButtonBounds = snapButton.bounds
        
        coverSnapView.layer.cornerRadius = coverSnapView.bounds.size.height / 2
        lineInCoverSnapView.layer.cornerRadius = lineInCoverSnapView.bounds.size.height / 2
        snapButton.layer.cornerRadius = snapButton.bounds.size.height / 2

        setupPickerView()
        setupSwipeRight()
        setupSwipeLeft()
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
        swipeCaptureViewRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeCaptureViewRightGesture.direction = .right
        captureView.addGestureRecognizer(swipeCaptureViewRightGesture)
        
        swipeBlurViewRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeBlurViewRightGesture.direction = .right
        blurView.addGestureRecognizer(swipeBlurViewRightGesture)
    }
    
    fileprivate func setupSwipeLeft() {
        swipeCaptureViewLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeCaptureViewLeftGesture.direction = .left
        captureView.addGestureRecognizer(swipeCaptureViewLeftGesture)
        
        swipeBlurViewLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeBlurViewLeftGesture.direction = .left
        blurView.addGestureRecognizer(swipeBlurViewLeftGesture)
    }
    
    fileprivate func setupCamera() {
        viewModel.prepareCamera()
    }
    
    fileprivate func beginCamera() {
        viewModel.beginCamera()
    }
    
    fileprivate func binding() {
        viewModel.receivedFeature = { [unowned self] (index) -> Void in
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
            self.pickerView.reloadAllComponents()
        }
        
        viewModel.enableAllView = { [unowned self] (enable) -> Void in
            self.pickerView.isUserInteractionEnabled = enable
            self.swipeCaptureViewLeftGesture.isEnabled = enable
            self.swipeCaptureViewRightGesture.isEnabled = enable
            self.swipeBlurViewLeftGesture.isEnabled = enable
            self.swipeBlurViewRightGesture.isEnabled = enable
            self.flipButton.isEnabled = enable
            self.flashButton.isEnabled = enable
            self.closeButton.isEnabled = enable
        }
        
        viewModel.hiddenBlurView = { [unowned self] (alpha) -> Void in
            UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                self.blurView.alpha = alpha
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.changeSnapButtonColor = { [unowned self] (color) -> Void in
            self.snapButton.backgroundColor = color
        }
        
        viewModel.changeImageFlashButton = { [unowned self] (image) -> Void in
            self.flashButton.setImage(image, for: .normal)
        }
        
        viewModel.changeImageSnapButton = { [unowned self] (image) -> Void in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
                self.snapButton.setImage(image, for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        viewModel.changeSquareViewHeight = { [unowned self] (height) -> Void in
            UIView.animate(withDuration: 0.3, animations: {
                self.topSquareViewHeightConstraint.constant = height
                self.bottomSquareViewHeightConstraint.constant = height
                self.view.layoutIfNeeded()
            })
        }

        viewModel.changeSnapButtonRadius = { [unowned self] (raduis, bounds) -> Void in
            UIView.animate(withDuration: 0.3, animations: {
                self.snapButton.layer.cornerRadius = raduis
                self.snapButton.bounds = bounds
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.hiddenLoadingView = { [unowned self] (hidden) -> Void in
            self.loadingView.isHidden = hidden
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

//MARK: Orientation
extension LFSSnapViewController {
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

//MARK: Remove all
extension LFSSnapViewController {
    fileprivate func removeAll() {
        coverPickerView = nil
        pickerView = nil
        captureView = nil
        coverCaptureView = nil
        coverSnapView = nil
        lineInCoverSnapView = nil
        snapButton = nil
        flipButton = nil
        flashButton = nil
        closeButton = nil
        blurView = nil
        loadingView = nil
        circularProgress = nil
        pickerViewHeightConstraint = nil
        pickerViewWidthConstraint = nil
        topSquareViewHeightConstraint = nil
        bottomSquareViewHeightConstraint = nil
        swipeBlurViewLeftGesture = nil
        swipeBlurViewRightGesture = nil
        swipeCaptureViewLeftGesture = nil
        swipeCaptureViewRightGesture = nil
        viewModel = nil
        features = nil
        delegate = nil
    }
}

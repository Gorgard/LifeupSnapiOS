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
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var colorPallateView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var coverSliderView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var penSizeView: UIView!
    
    //MARK: Constraint
    @IBOutlet weak var penSizeViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var penSizeViewWidthConstraint: NSLayoutConstraint!
    
    private weak var delegate: LFSDrawDelegate?
    
    internal var viewModel: LFSDrawViewModel!
    
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
    
    @IBAction func onTappedDone(_ sender: Any) {
        viewModel.close()
    }
    
    @IBAction func onTappedColorPallate(_ sender: Any) {
        viewModel.colorPallate()
    }
    
    @IBAction func onTappedEraser(_ sender: Any) {
        viewModel.eraser()
    }
    
    @IBAction func onTappedClear(_ sender: Any) {
        viewModel.clear()
    }
    
    @IBAction func onSlidePenSize(_ sender: Any) {
        viewModel.penSize(sender: sender)
    }
}

//MARK: Setups
extension LFSDrawViewController {
    fileprivate func setups() {
        viewModel = LFSDrawViewModel(delegate: self)
        viewModel.view = drawView
        viewModel.viewController = self
        
        viewModel.setup()
    }
    
    fileprivate func binding() {
        viewModel.openColorPallate = { [unowned self] (alpha) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.colorPallateView.alpha = alpha
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.changePallateButtonImage = { [unowned self] (image) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.colorPallateButton.setImage(image, for: .normal)
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.changePenSizeViewSize = { [unowned self] (width, height) -> Void in
            self.penSizeView.alpha = 1
            
            UIView.animate(withDuration: 0.2, animations: {
                self.penSizeViewWidthConstraint.constant = width
                self.penSizeViewHeightContraint.constant = height
                self.penSizeView.layer.cornerRadius = self.penSizeView.bounds.size.height / 2
                self.view.layoutIfNeeded()
            }, completion: { [unowned self] (finished) in
                self.didChangedPenSize()
            })
        }
        
        viewModel.changePallateColor = { [unowned self] (color) -> Void in
            self.penSizeView.layer.shadowColor = color?.color.cgColor
        }
        
        viewModel.receivedDrawView = { [unowned self] (drawView) -> Void in
            self.delegate?.draw(received: drawView)
        }
    
        viewModel.didDrawed = { [unowned self] () -> Void in
            self.delegate?.didDrawed()
        }
    }
    
    fileprivate func setupViews() {
        colorPallateView.backgroundColor = .clear
        
        viewModel.colorPallateViewAlpha = colorPallateView.alpha
        
        setupCollectionView()
        setupSliderView()
        setupPenSizeView()
    }
    
    fileprivate func setupCollectionView() {
        let nib = UINib(nibName: LFSConstants.LFSNibID.Edit.lsLabelColorCollectionViewCell, bundle: Bundle(for: LFSLabelColorCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lsLabelColorCollectionViewCell)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 25, height: 25)
        
        
        collectionView.backgroundColor = .clear
    }
    
    fileprivate func setupSliderView() {
        coverSliderView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.5)
        coverSliderView.layer.borderColor = UIColor.lightGray.cgColor
        coverSliderView.layer.borderWidth = 0.5
        coverSliderView.layer.cornerRadius = coverSliderView.bounds.size.height / 2
        coverSliderView.backgroundColor = .darkGray
    }
    
    fileprivate func setupPenSizeView() {
        penSizeView.layer.cornerRadius = penSizeView.bounds.size.height / 2
        penSizeView.layer.shadowColor = UIColor.black.cgColor
        penSizeView.layer.shadowOpacity = 1
        penSizeView.layer.shadowOffset = .zero
        penSizeView.layer.shadowRadius = 5
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension LFSDrawViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewModel.cellForItem(with: collectionView, at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelected(with: collectionView, at: indexPath)
    }
}


//MARK: LFSDrawViewModelDelegate
extension LFSDrawViewController: LFSDrawViewModelDelegate {
    internal func tappedDoneButton() {
        viewModel.generateDrawView()
    }
    
    internal func choosedColor() {
        collectionView.reloadData()
    }
}

//MARK: Handle Change Pen Size
extension LFSDrawViewController {
    fileprivate func didChangedPenSize() {
        UIView.animate(withDuration: 0.2, delay: 0.5, options: .allowUserInteraction, animations: { [unowned self] in
            self.penSizeView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

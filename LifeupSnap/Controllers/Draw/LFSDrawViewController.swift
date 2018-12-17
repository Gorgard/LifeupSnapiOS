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
        
        viewModel.didDrawed = { [unowned self] () -> Void in
            self.delegate?.didDrawed()
        }
    }
    
    fileprivate func setupViews() {
        colorPallateView.backgroundColor = .clear
        
        viewModel.colorPallateViewAlpha = colorPallateView.alpha
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let nib = UINib(nibName: LFSConstants.LFSNibID.Edit.lsLabelColorCollectionViewCell, bundle: Bundle(for: LFSLabelColorCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lsLabelColorCollectionViewCell)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 25, height: 25)
        
        
        collectionView.backgroundColor = .clear
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
        
    }
}

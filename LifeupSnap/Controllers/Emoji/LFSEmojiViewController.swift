//
//  LFSEmojiViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

class LFSEmojiViewController: UIViewController {
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var slideDownButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal var viewModel: LFSEmojiViewModel!
    
    private weak var delegate: LFSEmojiDelegate?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init(delegate: LFSEmojiDelegate) {
        let bundle = Bundle(for: LFSEmojiViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Edit.lfsEmojiViewController, bundle: bundle)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedSlideDown(_ sender: Any) {
        viewModel.close()
    }
}

//MARK: Setups
extension LFSEmojiViewController {
    fileprivate func setup() {
        viewModel = LFSEmojiViewModel(delegate: self)
        viewModel.viewController = self
        
        viewModel.setup()
    }
    
    fileprivate func binding() {
        
    }
    
    fileprivate func setupViews() {
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let nib = UINib(nibName: LFSConstants.LFSNibID.Edit.lfsEmojiCollectionViewCell, bundle: Bundle(for: LFSEmojiCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiCollectionViewCell)
        
        collectionView.backgroundColor = .clear
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension LFSEmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

//MARK: LFSEmojiViewModelDelegate
extension LFSEmojiViewController: LFSEmojiViewModelDelegate {
    func dismissedView() {
        
    }
}

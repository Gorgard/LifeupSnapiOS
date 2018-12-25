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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
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

    deinit {
        removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setup()
        super.viewWillAppear(animated)
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
    }
    
    fileprivate func binding() {
        viewModel.didChoose = { [unowned self] () -> Void in
            self.delegate?.dismissedView()
        }
        
        viewModel.receivedEmojiView = { [unowned self] (emojiView) -> Void in
            self.delegate?.emoji(recieved: emojiView)
        }
    }
    
    fileprivate func setupViews() {
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let nibSystem = UINib(nibName: LFSConstants.LFSNibID.Edit.lfsEmojiSystemCollectionViewCell, bundle: Bundle(for: LFSEmojiSystemCollectionViewCell.self))
        let nibSelf = UINib(nibName: LFSConstants.LFSNibID.Edit.lfsEmojiSelfCollectionViewCell, bundle: Bundle(for: LFSEmojiSelfCollectionViewCell.self))
        
        collectionView.register(nibSystem, forCellWithReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiSystemCollectionViewCell)
        collectionView.register(nibSelf, forCellWithReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiSelfCollectionViewCell)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 50, height: 50)
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        collectionView.backgroundColor = .clear
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension LFSEmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(section: section)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewModel.cellForItem(with: collectionView, at: indexPath)
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelected(with: collectionView, at: indexPath)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

//MARK: LFSEmojiViewModelDelegate
extension LFSEmojiViewController: LFSEmojiViewModelDelegate {
    func choosedEmoji() {
        viewModel.generateEmoji()
        viewModel.close()
    }
    
    func dismissedView() {
        
    }
    
    func fetchedEmoji() {
        collectionView.reloadData()
        indicatorView.stopAnimating()
    }
}

//MARK: UIScrollViewDelegate
extension LFSEmojiViewController: UIScrollViewDelegate {
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView: scrollView)
    }
}

//MARK: Remove all
extension LFSEmojiViewController {
    fileprivate func removeAll() {
        emojiView = nil
        slideDownButton = nil
        blurView = nil
        collectionView = nil
        indicatorView = nil
        delegate = nil
        viewModel = nil
    }
}

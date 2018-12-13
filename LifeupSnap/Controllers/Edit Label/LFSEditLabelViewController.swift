//
//  LFSEditLabelViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditLabelViewController: UIViewController {
    @IBOutlet weak var colorPallateButton: UIButton!
    @IBOutlet weak var borderButton: UIButton!
    @IBOutlet weak var doneButton: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var colorPallateView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private weak var delegate: LFSEditLabelDelegate?
    
    internal var viewModel: LFSEditLabelViewModel!

    internal var label: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init(delegate: LFSEditLabelDelegate) {
        let bundle = Bundle(for: LFSEditLabelViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Edit.lfsEditLabelViewController, bundle: bundle)
        
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
    
    @IBAction func onTappedDone(_ sender: Any) {
        viewModel.close()
    }
    
    @IBAction func onTappedColorPallate(_ sender: Any) {
        viewModel.colorPallate()
    }
    
    @IBAction func onTappedBorder(_ sender: Any) {
        
    }
    
    @IBAction func handleSingleTap(_ sender: Any) {
        messageTextView.resignFirstResponder()
    }
}

//MARK: Setups
extension LFSEditLabelViewController {
    fileprivate func setup() {
        viewModel = LFSEditLabelViewModel(delegate: self)
        viewModel.label = label
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
    }
    
    fileprivate func setupViews() {
        borderButton.layer.cornerRadius = 8
        borderButton.layer.borderColor = UIColor.white.cgColor
        borderButton.layer.borderWidth = 2

        colorPallateView.backgroundColor = .clear
        
        viewModel.colorPallateViewAlpha = colorPallateView.alpha
        
        setupCollectionView()
        setupTextView()
    }
    
    fileprivate func setupTextView() {
        messageTextView.text = LFSConstants.LFSPlaceholder.Edit.startTyping
        messageTextView.textColor = .lightGray
        messageTextView.returnKeyType = .done
        messageTextView.delegate = self
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
extension LFSEditLabelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

//MARK: UITextViewDelegate
extension LFSEditLabelViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel.textViewDidBeginEditing(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return viewModel.textView(textView: textView, range: range, text: text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.textViewDidEndEditing(textView: textView)
    }
}

//MARK: LFSEditLabelViewModelDelegate
extension LFSEditLabelViewController: LFSEditLabelViewModelDelegate {
    
}

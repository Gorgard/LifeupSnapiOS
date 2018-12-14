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
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var colorPallateView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Constraint
    @IBOutlet weak var messageTextViewTopConstraint: NSLayoutConstraint!
    
    private weak var delegate: LFSEditLabelDelegate?
    
    internal var viewModel: LFSEditLabelViewModel!

    internal var attributeString: NSMutableAttributedString!
    
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
        viewModel.border()
    }
}

//MARK: Setups
extension LFSEditLabelViewController {
    fileprivate func setup() {
        viewModel = LFSEditLabelViewModel(delegate: self)
        viewModel.currentAttributeString = attributeString
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
        
        viewModel.changeTextAttribute = { [unowned self] (attribute) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.messageTextView.attributedText = attribute
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.messageTextViewMaxHeight = { [unowned self] (height) -> Void in
            self.messageTextView.maxHeight = height
        }
        
        viewModel.receivedAttributeString = { [unowned self] (attribute) -> Void in
            self.delegate?.editLabel(attributeString: attribute)
            self.delegate?.editedLabel()
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
        messageTextView.placeholder = LFSConstants.LFSPlaceholder.Edit.startTyping
        messageTextView.returnKeyType = .done
        messageTextView.backgroundColor = .clear
        messageTextView.delegate = self
        
        viewModel.messageTextViewTopConstraint = messageTextViewTopConstraint.constant
        
        messageTextView.becomeFirstResponder()
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
    func textViewDidChange(_ textView: UITextView) {
        viewModel.textViewDidChange(textView: textView)
    }
}

//MARK: LFSEditLabelViewModelDelegate
extension LFSEditLabelViewController: LFSEditLabelViewModelDelegate {
    func tappedDoneButton() {
        messageTextView.resignFirstResponder()
        viewModel.generateAttributeString()
    }
}

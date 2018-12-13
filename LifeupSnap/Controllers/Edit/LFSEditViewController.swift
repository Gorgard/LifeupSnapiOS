//
//  LFSEditViewController.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var labelButton: UIButton!
    @IBOutlet weak var paintingButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var editingView: UIView!

    internal var viewModel: LFSEditViewModel!
    
    internal var editEvent: EditEvent!
    
    internal var image: UIImage?
    internal var url: URL?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal init() {
        let bundle = Bundle(for: LFSEditViewController.self)
        super.init(nibName: LFSConstants.LFSNibID.Edit.lfsEditViewController, bundle: bundle)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.begin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        viewModel.close()
    }
    
    @IBAction func onTappedSticker(_ sender: Any) {
        
    }
    
    @IBAction func onTappedLabel(_ sender: Any) {
        viewModel.label()
    }
    
    @IBAction func onTappedPainting(_ sender: Any) {
        
    }
    
    @IBAction func onTappedNext(_ sender: Any) {
        
    }
}

//MARK: Setups
extension LFSEditViewController {
    fileprivate func setup() {
        viewModel = LFSEditViewModel(delegate: self)
        viewModel.editEvent = editEvent
        viewModel.image = image
        viewModel.url = url
        viewModel.viewController = self
    }
    
    fileprivate func binding() {
        viewModel.receivedThumbnailImage = { [unowned self] (image) -> Void in
            self.previewImageView.image = image
        }
        
        viewModel.hiddenAllView = { [unowned self] (hidden) -> Void in
            self.backButton.isHidden = hidden
            self.stickerButton.isHidden = hidden
            self.labelButton.isHidden = hidden
            self.paintingButton.isHidden = hidden
            self.nextButton.isHidden = hidden
        }
        
        viewModel.binding()
    }
    
    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = nextButton.bounds.size.height / 2
        nextButton.layer.shadowColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 0
    }
}

//MARK: LFSEditViewModelDelegate
extension LFSEditViewController: LFSEditViewModelDelegate {
    
}

//
//  LFSEditViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditViewModel: LFSViewModel {
    private weak var delegate: LFSEditViewModelDelegate?
    internal weak var baseDelegate: LFSSnapDelegate?
    
    internal var editEvent: EditEvent!
    
    internal var image: UIImage?
    internal var url: URL?
    
    internal var receivedThumbnailImage: ((_ image: UIImage?) -> Void)?
    internal var hiddenLoadingView: ((_ hidden: Bool) -> Void)?
    internal var hiddenAllView: ((_ hidden: Bool) -> Void)?
    
    private var labels: [DragLabel]!
    private var images: [UIImage]!
    private var emojis: [EmojiView]!
    
    init(delegate: LFSEditViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        labels = [DragLabel]()
        images = [UIImage]()
        emojis = [EmojiView]()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditTextView(notification:)), name: NSNotification.Name(rawValue: LFSConstants.NotificationCenterID.DragLabel.editLabel), object: nil)
    }
    
    override func close() {
        handleClose(accept: { () -> Void in
            
        }, cancel: { () -> Void in
            super.close()
        })
    }
}

//MARK: Base
extension LFSEditViewModel {
    internal func binding() {
        switch editEvent {
        case .photo:
            thumbnailPhoto()
            break
        case .video:
            thumbnailVideo()
            break
        default:
            break
        }
    }
    
    internal func begin() {
        hiddenAllView?(false)
    }
}

//MARK: Handle Close
extension LFSEditViewModel {
    fileprivate func handleClose(accept: @escaping() -> Void, cancel: @escaping() -> Void) {
        if labels.count > 0 || images.count > 0 || emojis.count > 0 {
            let alertController = AlertController(title: LFSConstants.LFSAlertWording.discardTitle,
                                                  message: LFSConstants.LFSAlertWording.photoWillDelete,
                                                  acceptButtonTitle: LFSConstants.LFSAlertWording.keep,
                                                  cancelButtonTitle: LFSConstants.LFSAlertWording.discard)
            
            alertController.show(viewController: viewController!, accept: { (alert) -> Void in
                accept()
            }, cancel: { (alert) -> Void in
                cancel()
            })
        }
        else {
            cancel()
        }
    }
}

//MARK: Handle Action
extension LFSEditViewModel {
    internal func label(dragLabel: DragLabel? = nil) {
        let lfsEditLabelViewController = LFSEditLabelViewController(delegate: self)
        lfsEditLabelViewController.dragLabel = dragLabel
        
        lfsEditLabelViewController.modalPresentationStyle = .overFullScreen
        
        hiddenAllView?(true)
        
        viewController?.present(lfsEditLabelViewController, animated: true, completion: nil)
    }
    
    internal func draw() {
        let lfsDrawViewController = LFSDrawViewController(delegate: self)
        lfsDrawViewController.modalPresentationStyle = .overFullScreen
        
        hiddenAllView?(true)
        
        viewController?.present(lfsDrawViewController, animated: true, completion: nil)
    }
    
    internal func emoji() {
        let lfsEmojiViewController: LFSEmojiViewController = LFSEmojiViewController(delegate: self)
        lfsEmojiViewController.modalPresentationStyle = .overFullScreen
      
        hiddenAllView?(true)
        
        viewController?.present(lfsEmojiViewController, animated: true, completion: nil)
    }
    
    internal func next() {
        hiddenLoadingView?(false)
        hiddenAllView?(true)
        merge()
    }
}

//MARK: Thumbnail
extension LFSEditViewModel {
    private func thumbnailVideo() {
        if let url = url {
            let thumbnailImage = LFSVideoModel.shared.thumnailImage(from: url)
            
            receivedThumbnailImage?(thumbnailImage)
        }
    }
    
    private func thumbnailPhoto() {
        receivedThumbnailImage?(image)
    }
}

//MARK: LFSEditLabelDelegate
extension LFSEditViewModel: LFSEditLabelDelegate {
    internal func editLabel(recieved dragLabel: DragLabel) {
        if !labels.contains(dragLabel) {
            addDragLabel(dragLabel: dragLabel)
        }
    }
    
    internal func editedLabel() {
        hiddenAllView?(false)
    }
    
    fileprivate func addDragLabel(dragLabel: DragLabel) {
        dragLabel.center = view!.center
        
        view?.addSubview(dragLabel)
        
        labels.append(dragLabel)
    }
}

//MARK: LFSDrawDelegate
extension LFSEditViewModel: LFSDrawDelegate {
    internal func draw(received drawView: DrawView) {
        let image = drawView.image()
        
        if !images.contains(image) {
            addImage(image: image)
        }
    }
    
    internal func didDrawed() {
        hiddenAllView?(false)
    }
    
    fileprivate func addImage(image: UIImage) {
        let imageView = UIImageView(frame: view!.bounds)
        imageView.image = image
        
        view?.addSubview(imageView)
        
        images.append(image)
    }
}

//MARK: LFSEmojiDelegate
extension LFSEditViewModel: LFSEmojiDelegate {
    internal func emoji(recieved emojiView: EmojiView) {
        if !emojis.contains(emojiView) {
            addEmoji(emojiView: emojiView)
        }
    }
    
    internal func dismissedView() {
        hiddenAllView?(false)
    }
    
    fileprivate func addEmoji(emojiView: EmojiView) {
        emojiView.center = view!.center
        
        view?.addSubview(emojiView)
        
        emojis.append(emojiView)
    }
}

//MARK: Handle Notification Edit TextView
extension LFSEditViewModel {
    @objc fileprivate func handleEditTextView(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any], let dragLabel = userInfo["dragLabel"] as? DragLabel {
            label(dragLabel: dragLabel)
        }
    }
}

//MARK: Merge
extension LFSEditViewModel {
    fileprivate func merge() {
        switch editEvent {
        case .photo:
            mergePhoto()
            break
        case .video:
            mergeVideo()
            break
        default:
            break
        }
    }
    
    fileprivate func mergePhoto() {
        guard let image = image, let view = view else { return }
        let renderedEditedImage = LFSEditModel.shared.renderImage(view: view)
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = image
        backgroundImageView.backgroundColor = .clear
        
        let editedImageView = UIImageView(frame: view.bounds)
        editedImageView.contentMode = .scaleAspectFit
        editedImageView.image = renderedEditedImage
        editedImageView.backgroundColor = .clear
        
        let baseView = UIView(frame: view.bounds)
        baseView.backgroundColor = .clear
        baseView.addSubview(backgroundImageView)
        baseView.addSubview(editedImageView)
        
        let renderedCompleteImage = LFSEditModel.shared.renderImage(view: baseView)
        
        gotoPhotoEditedPreview(image: renderedCompleteImage)
    }
    
    fileprivate func gotoPhotoEditedPreview(image: UIImage) {
        let lfsPhotoEditedPreviewViewController = LFSPhotoEditedPreviewViewController()
        lfsPhotoEditedPreviewViewController.image = image
        lfsPhotoEditedPreviewViewController.baseDelegate = baseDelegate
        lfsPhotoEditedPreviewViewController.modalPresentationStyle = .overFullScreen
        
        viewController?.present(lfsPhotoEditedPreviewViewController, animated: true, completion: nil)
        
        hiddenLoadingView?(true)
        hiddenAllView?(false)
    }
    
    fileprivate func mergeVideo() {
        guard let url = url, let view = view else { return }
        
        var originalVideo: Bool = true
        if url.absoluteString.contains(LFSConstants.LFSVideoName.Snap.snapMergedVideo) {
            originalVideo = false
        }
        
        LFSVideoModel.shared.mergeEditedVideo(url: url, originalVideo: originalVideo, view: view, completion: { [unowned self] (editedURL) -> Void in
            self.goToVideoEditedPreview(url: editedURL)
        })
    }
    
    fileprivate func goToVideoEditedPreview(url: URL?) {
        guard let url = url else { return }
        
        let lfsVideoEditedPreviewViewController = LFSVideoEditedPreviewViewController()
        lfsVideoEditedPreviewViewController.url = url
        lfsVideoEditedPreviewViewController.baseDelegate = baseDelegate
        lfsVideoEditedPreviewViewController.modalPresentationStyle = .overFullScreen
        
        viewController?.present(lfsVideoEditedPreviewViewController, animated: true, completion: nil)
        
        hiddenLoadingView?(true)
        hiddenAllView?(false)
    }
}

//MARK: Remove all
extension LFSEditViewModel {
    fileprivate func removeAll() {
        delegate = nil
        editEvent = nil
        image = nil
        url = nil
        receivedThumbnailImage = nil
        hiddenAllView = nil
        labels = nil
        images = nil
    }
}

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
    
    internal var editEvent: EditEvent!
    
    internal var image: UIImage?
    internal var url: URL?
    
    internal var receivedThumbnailImage: ((_ image: UIImage?) -> Void)?
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
        
    }
    
    fileprivate func mergeVideo() {
        LFSVideoModel.shared.mergeEditedVideo(url: url!, view: view!, completion: { [unowned self] (_url) -> Void in
            LFSVideoModel.shared.playSimpleVideo(url: _url!, viewController: self.viewController!)
        })
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

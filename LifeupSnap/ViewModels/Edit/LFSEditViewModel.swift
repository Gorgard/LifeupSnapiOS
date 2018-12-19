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
    private var drawViews: [DrawView]!
    
    init(delegate: LFSEditViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        labels = [DragLabel]()
        drawViews = [DrawView]()
        
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
        let center = view!.center
        dragLabel.center = center
        
        view?.addSubview(dragLabel)
        
        labels.append(dragLabel)
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

//MARK: LFSDrawDelegate
extension LFSEditViewModel: LFSDrawDelegate {
    internal func draw(received drawView: DrawView) {
        if !drawViews.contains(drawView) {
            addDrawView(drawView: drawView)
        }
    }
    
    internal func didDrawed() {
        hiddenAllView?(false)
    }
    
    fileprivate func addDrawView(drawView: DrawView) {
        let frame = view!.frame
        drawView.frame = frame
        
        view?.addSubview(drawView)
        
        drawViews.append(drawView)
    }
}

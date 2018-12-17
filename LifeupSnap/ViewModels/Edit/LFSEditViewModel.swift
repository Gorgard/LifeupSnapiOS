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
    
    private var textViews: [DragTextView]!
    
    init(delegate: LFSEditViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        textViews = [DragTextView]()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditTextView(notification:)), name: NSNotification.Name(rawValue: LFSConstants.NotificationCenterID.DragTextView.editTextView), object: nil)
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
    internal func label(dragTextView: DragTextView? = nil) {
        let lfsEditLabelViewController = LFSEditLabelViewController(delegate: self)
        lfsEditLabelViewController.dragTextView = dragTextView
        
        lfsEditLabelViewController.modalPresentationStyle = .overFullScreen
        
        hiddenAllView?(true)
        
        viewController?.present(lfsEditLabelViewController, animated: true, completion: nil)
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
    func editLabel(recieved dragTextView: DragTextView) {
        if !textViews.contains(dragTextView) {
            let center = view!.center
            dragTextView.center = center
            
            view?.addSubview(dragTextView)
            
            textViews.append(dragTextView)
        }
    }
    
    internal func editedLabel() {
        hiddenAllView?(false)
    }
}

//MARK: Handle Notification Edit TextView
extension LFSEditViewModel {
    @objc fileprivate func handleEditTextView(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any], let dragTextView = userInfo["dragTextView"] as? DragTextView {
            label(dragTextView: dragTextView)
        }
    }
}

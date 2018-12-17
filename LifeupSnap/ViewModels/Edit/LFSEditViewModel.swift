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
    internal func label() {
        let lfsEditLabelViewController = LFSEditLabelViewController(delegate: self)
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
        let textView = dragTextView
        
        var text = textView.text.replacingOccurrences(of: "\n", with: "")
        text = textView.text.inserting(separator: "\n", every: 18)
        
        textView.text = text
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.sizeToFit()
        
        let center = view!.center
        textView.center = center
        
        view?.addSubview(textView)
        
        textViews.append(textView)
    }
    
    internal func editedLabel() {
        hiddenAllView?(false)
    }
}

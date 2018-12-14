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
    
    private var textViews: [UITextView]!
    
    init(delegate: LFSEditViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        textViews = [UITextView]()
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
    internal func editLabel(attributeString: NSMutableAttributedString) {
        handleEditLabel(attributeString: attributeString)
    }
    
    internal func editedLabel() {
        hiddenAllView?(false)
    }
    
    private func handleEditLabel(attributeString: NSMutableAttributedString) {
        let textView = UITextView()
        textView.isUserInteractionEnabled = true
        textView.attributedText = attributeString
        textView.backgroundColor = .clear
       
        let size = LFSEditModel.shared.calculateSizeOfTextView(attributeString: attributeString)
        
        textView.frame = CGRect(x: view!.frame.midX, y: view!.frame.midY, width: size.width, height: size.height)
        
        let center = view!.center
        textView.center = center
        
        view?.addSubview(textView)
        
        textViews.append(textView)
    }
}

//MARK: Pan Gesture
extension LFSEditViewModel {
    internal func panView(gesture: UIPanGestureRecognizer) {
        view!.bringSubview(toFront: textViews.first!)
        let translation = gesture.translation(in: view)
        textViews.first!.center = CGPoint(x: textViews.first!.center.x + translation.x, y: textViews.first!.center.y + translation.y)
        
        gesture.setTranslation(.zero, in: view!)
    }
}

//
//  LFSEditLabelViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditLabelViewModel: LFSViewModel {
    private weak var delegate: LFSEditLabelViewModelDelegate?
    
    internal var pallateColors: [LFSColor]!
    private var currentPallateColor: LFSColor?
    
    internal var colorPallateViewAlpha: CGFloat!
    
    private var text: String?
    private var textColor: UIColor?
    private var borderTextColor: UIColor?
    private var font: UIFont?
    private var textAlignment: NSTextAlignment?
    
    internal var messageTextViewTopConstraint: CGFloat!
    
    private var isBorder: Bool = false
    
    internal var openColorPallate: ((_ alpha: CGFloat) -> Void)?
    internal var changeTextAttribute: ((_ attribute: NSMutableAttributedString) -> Void)?
    internal var changePallateButtonImage: ((_ image: UIImage) -> Void)?
    internal var messageTextViewMaxHeight: ((_ height: CGFloat) -> Void)?
    internal var receivedDragTextView: ((_ dragTextView: DragTextView) -> Void)?
    internal var newMessageTextView: ((_ textColor: UIColor?, _ borderTextColor: UIColor?) -> Void)?
    
    init(delegate: LFSEditLabelViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func close() {
        attributeText()
        delegate?.tappedDoneButton()
        super.close()
    }
}

//MARK: Base
extension LFSEditLabelViewModel {
    internal func setup() {
        let pallateColor = LFSPallateColor()
        pallateColors = pallateColor.colors
        
        currentPallateColor = LFSColor(name: "Black", color: .black)
    }
}

//MARK: Handle Action
extension LFSEditLabelViewModel {
    internal func colorPallate() {
        if colorPallateViewAlpha == 0 {
            colorPallateViewAlpha = 1
            changePallateButtonImage?(#imageLiteral(resourceName: "ic_edit_close.png"))
        }
        else {
            colorPallateViewAlpha = 0
            changePallateButtonImage?(#imageLiteral(resourceName: "ic_edit_pallate.png"))
        }
        
        openColorPallate?(colorPallateViewAlpha)
    }
    
    internal func border() {
        isBorder = !isBorder
        attributeText()
    }
    
    private func changeTextColor() {
        attributeText()
    }
}

//MARK: Text Attribute
extension LFSEditLabelViewModel {
    private func attributeText() {
        if isBorder {
            textColor = .white
            borderTextColor = currentPallateColor?.color ?? .black
        }
        else {
            textColor = currentPallateColor?.color ?? .black
            borderTextColor = .clear
        }
        
        newMessageTextView?(textColor, borderTextColor)
    }
}

//MARK: LFSCollectionViewPresentable
extension LFSEditLabelViewModel: LFSCollectionViewPresentable {
    internal func numberOfSections() -> Int {
        return 1
    }
    
    internal func numberOfItems(section: Int) -> Int {
        return pallateColors.count
    }
    
    internal func cellForItem(with collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lsLabelColorCollectionViewCell, for: indexPath) as! LFSLabelColorCollectionViewCell
        let pallateColor = pallateColors[indexPath.row]
        
        cell.labelColorView.backgroundColor = pallateColor.color
       
        return cell
    }
    
    internal func didSelected(with collectionView: UICollectionView, at indexPath: IndexPath) {
        let pallateColor = pallateColors[indexPath.row]
        currentPallateColor = pallateColor
        
        attributeText()
    }
}

//MARK: Handle UITextViewDelegate
extension LFSEditLabelViewModel {
    internal func textViewDidChange(textView: UITextView) {
        text = textView.text
    }
}

//MARK: Handle Keyboard
extension LFSEditLabelViewModel {
    @objc private func keyboardWillShow(notification: Notification) {
        if let keybaordFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keybaordFrame.cgRectValue
            let keyboardHeight = keyboardRect.size.height
            setTextViewMaxHeight(keyboardHeight: keyboardHeight)
        }
    }
    
    fileprivate func setTextViewMaxHeight(keyboardHeight: CGFloat) {
        let estimateHeight = (UIScreen.main.bounds.height - keyboardHeight) - (messageTextViewTopConstraint + 30)
        messageTextViewMaxHeight?(estimateHeight)
    }
}

//MARK: Send Value by LFSEditLabelDelegate
extension LFSEditLabelViewModel {
    internal func generateDragTextView() {
        guard let text = text, let textColor = textColor, let borderTextColor = borderTextColor else {
            return
        }
        
        let dragTextView = DragTextView()
        dragTextView.text = text
        dragTextView.textColor = textColor
        dragTextView.borderTextColor = borderTextColor
        dragTextView.font = font ?? UIFont.systemFont(ofSize: 30, weight: .medium)
        dragTextView.textAlignment = textAlignment ?? .center
        
        receivedDragTextView?(dragTextView)
    }
}

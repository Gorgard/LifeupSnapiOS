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
    internal var currentColor: LFSColor?
    
    internal var colorPallateViewAlpha: CGFloat!
    
    internal var dragLabel: DragLabel?
    
    private var text: String?
    private var textColor: UIColor?
    private var borderTextColor: UIColor?
    private var isBorder: Bool = false
    
    internal var messageTextViewTopConstraint: CGFloat!
    
    internal var openColorPallate: ((_ alpha: CGFloat) -> Void)?
    internal var changePallateButtonImage: ((_ image: UIImage) -> Void)?
    internal var messageTextViewMaxHeight: ((_ height: CGFloat) -> Void)?
    internal var textOfMessageTextView: ((_ text: String?) -> Void)?
    internal var receivedDragLabel: ((_ dragTextView: DragLabel) -> Void)?
    internal var newMessageTextView: ((_ textColor: UIColor?, _ borderTextColor: UIColor?) -> Void)?
    internal var editedLabel: (() -> Void)?
    
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
    }
    
    internal func binding() {
        if let dragLabel = dragLabel {
            text = dragLabel.text
            textColor = dragLabel.textColor
            borderTextColor = dragLabel.borderTextColor
            isBorder = dragLabel.isBorder
            currentColor = dragLabel.currentColor
        }
        else {
            currentColor = LFSColor(name: "Black", color: .black)
        }

        attributeText()
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
}

//MARK: Text Attribute
extension LFSEditLabelViewModel {
    private func attributeText() {
        if isBorder {
            textColor = .white
            borderTextColor = currentColor?.color ?? .black
        }
        else {
            textColor = currentColor?.color ?? .black
            borderTextColor = .clear
        }
        
        textOfMessageTextView?(text)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsLabelColorCollectionViewCell, for: indexPath) as! LFSLabelColorCollectionViewCell
        let pallateColor = pallateColors[indexPath.row]
        
        cell.labelColorView.backgroundColor = pallateColor.color
       
        if pallateColor.name == currentColor?.name {
            cell.choosedColorView.backgroundColor = .black
        }
        else {
            cell.choosedColorView.backgroundColor = .clear
        }
        
        return cell
    }
    
    internal func didSelected(with collectionView: UICollectionView, at indexPath: IndexPath) {
        let pallateColor = pallateColors[indexPath.row]
        currentColor = pallateColor
        
        attributeText()
        
        delegate?.choosedColor()
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
    internal func generateDragLabel() {
        guard let text = text, !text.isEmpty, let textColor = textColor, let borderTextColor = borderTextColor else {
            editedLabel?()
            return
        }
        
        var dragLabel: DragLabel
        
        if let _dragLabel = self.dragLabel {
            dragLabel = _dragLabel
        }
        else {
            dragLabel = DragLabel()
        }
        
        dragLabel.borderTextColor = borderTextColor
        dragLabel.isBorder = isBorder
        dragLabel.currentColor = currentColor
        dragLabel.text = text
        dragLabel.textColor = textColor
        
        let frame = CGRect(x: dragLabel.frame.origin.x, y: dragLabel.frame.origin.y, width: dragLabel.currentWidth, height: dragLabel.currentHeight)
        dragLabel.frame = frame
        dragLabel.sizeToFit()
      
        dragLabel.setBorderLabel()
        
        receivedDragLabel?(dragLabel)
        editedLabel?()
    }
}

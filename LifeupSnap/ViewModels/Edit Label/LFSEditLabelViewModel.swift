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
    
    internal var label: UILabel!
    internal var colorPallateViewAlpha: CGFloat!
    
    private var text: String?
    internal var placeholderColor: UIColor!
    
    internal var isBorder: Bool = false
    
    internal var openColorPallate: ((_ alpha: CGFloat) -> Void)?
    internal var changeTextAttribute: ((_ attribute: NSMutableAttributedString) -> Void)?
    internal var changePallateButtonImage: ((_ image: UIImage) -> Void)?
    
    init(delegate: LFSEditLabelViewModelDelegate) {
        self.delegate = delegate
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
        guard let attributeString = LFSEditModel.shared.attributeText(text: text, currentPalleteColor: currentPallateColor, isBorder: isBorder) else {
            return
        }
        
        changeTextAttribute?(attributeString)
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
    internal func textViewTextChange(textView: UITextView) {
        text = textView.text
    }
}

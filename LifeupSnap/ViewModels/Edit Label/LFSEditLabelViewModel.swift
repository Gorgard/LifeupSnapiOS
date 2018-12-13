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
    
    internal var label: UILabel!
    internal var colorPallateViewAlpha: CGFloat!
    
    internal var text: String?
    internal var placeholderColor: UIColor!
    
    private var textColor: UIColor = .black
    
    internal var openColorPallate: ((_ alpha: CGFloat) -> Void)?
    internal var changeTextColor: ((_ color: UIColor) -> Void)?
    
    init(delegate: LFSEditLabelViewModelDelegate) {
        self.delegate = delegate
    }
}

//MARK: Base
extension LFSEditLabelViewModel {
    internal func setup() {
        let pallateColor = LFSPallateColor()
        pallateColors = pallateColor.colors
    }
}

//MARK: Handle Action
extension LFSEditLabelViewModel {
    internal func colorPallate() {
        if colorPallateViewAlpha == 0 {
            colorPallateViewAlpha = 1
        }
        else {
            colorPallateViewAlpha = 0
        }
        openColorPallate?(colorPallateViewAlpha)
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
        textColor = pallateColor.color
        changeTextColor?(textColor)
    }
}

//MARK: Handle PlaceholderTextView
extension LFSEditLabelViewModel {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == LFSConstants.LFSPlaceholder.Edit.startTyping && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = textColor
        }
    }
    
    func textView(textView: UITextView, range: NSRange, text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" && textView.textColor != .lightGray {
            textView.text = LFSConstants.LFSPlaceholder.Edit.startTyping
            textView.textColor = UIColor.lightGray
        }
    }
}

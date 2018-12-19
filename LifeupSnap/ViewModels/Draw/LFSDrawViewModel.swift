//
//  LFSDrawViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 17/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSDrawViewModel: LFSViewModel {
    private weak var delegate: LFSDrawViewModelDelegate?
    
    private var drawView: DrawView!
    
    private var pallateColors: [LFSColor]!
    private var currentColor: LFSColor?
    
    internal var colorPallateViewAlpha: CGFloat!
    internal var minimumPenSize: CGFloat!
    internal var maximumPenSize: CGFloat!
    
    internal var openColorPallate: ((_ alpha: CGFloat) -> Void)?
    internal var changePallateButtonImage: ((_ image: UIImage) -> Void)?
    internal var changePallateColor: ((_ color: LFSColor?) -> Void)?
    internal var changePenSizeViewColor: ((_ color: LFSColor?) -> Void)?
    internal var changePenSizeViewSize: ((_ width: CGFloat, _ height: CGFloat) -> Void)?
    internal var changeLineWidth: ((_ width: CGFloat) -> Void)?
    internal var didDrawed: (() -> Void)?
    internal var didClear: (() -> Void)?
    
    init(delegate: LFSDrawViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    override func close() {
        delegate?.tappedDoneButton()
        didDrawed?()
        super.close()
    }
}

//MARK: Base
extension LFSDrawViewModel {
    internal func setup() {
        if let drawView = view as? DrawView {
            self.drawView = drawView
        }
        
        let pallateColor = LFSPallateColor()
        pallateColors = pallateColor.colors
    }
}

//MARK: Handle Action
extension LFSDrawViewModel {
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
    
    internal func penSize(sender: Any) {
        let slider = sender as! UISlider
        let value = CGFloat(slider.value)
        changePenSizeViewSize?(value, value)
        changeLineWidth?(value)
    }
    
    internal func clear() {
        didClear?()
    }
    
    internal func eraser() {
        currentColor = LFSColor(name: "Clear", color: .clear)
        changePallateColor?(currentColor)
        delegate?.choosedColor()
    }
}

//MARK: LFSCollectionViewPresentable
extension LFSDrawViewModel: LFSCollectionViewPresentable {
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
        changePallateColor?(currentColor)
        delegate?.choosedColor()
    }
}

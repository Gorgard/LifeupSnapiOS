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
    internal var receivedDrawView: ((_ drawView: DrawView) -> Void)?
    internal var didDrawed: (() -> Void)?
    internal var didClear: (() -> Void)?
    
    init(delegate: LFSDrawViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    deinit {
        removeAll()
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
            changePallateButtonImage?(LFSPhotoModel.shared.imageBundle(named: kIconEditClose, fromClass: LFSDrawViewModel.self)!)
        }
        else {
            colorPallateViewAlpha = 0
            changePallateButtonImage?(LFSPhotoModel.shared.imageBundle(named: kIconEditPallate, fromClass: LFSDrawViewModel.self)!)
        }
        
        openColorPallate?(colorPallateViewAlpha)
    }
    
    internal func penSize(sender: Any) {
        let slider = sender as! UISlider
        let value = CGFloat(slider.value)
        changePenSizeViewSize?(value, value)
        
        drawView.lineWidth = value
    }
    
    internal func clear() {
        drawView.clear()
    }
    
    internal func eraser() {
        currentColor = LFSColor(name: "Clear", color: .clear)
        drawView.currentColor = currentColor
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLfsLabelColorCollectionViewCell, for: indexPath) as! LFSLabelColorCollectionViewCell
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
        drawView.currentColor = currentColor
        
        changePallateColor?(currentColor)
        
        delegate?.choosedColor()
    }
}

//MARK: Send Value by LFSDrawDelegate
extension LFSDrawViewModel {
    internal func generateDrawView() {
        guard let drawView = drawView, let lines = drawView.lines, lines.count > 0 else {
            didDrawed?()
            return
        }
        
        receivedDrawView?(drawView)
        didDrawed?()
    }
}

//MARK: Remove all
extension LFSDrawViewModel {
    fileprivate func removeAll() {
        delegate = nil
        drawView = nil
        pallateColors = nil
        currentColor = nil
        colorPallateViewAlpha = nil
        minimumPenSize = nil
        maximumPenSize = nil
        openColorPallate = nil
        changePallateButtonImage = nil
        changePallateColor = nil
        changePenSizeViewColor = nil
        changePenSizeViewSize = nil
        receivedDrawView = nil
        didDrawed = nil
        didClear = nil
    }
}

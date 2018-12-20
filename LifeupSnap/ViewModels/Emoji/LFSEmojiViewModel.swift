//
//  LFSEmojiViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 20/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEmojiViewModel: LFSViewModel {
    private weak var delegate: LFSEmojiViewModelDelegate?
    
    private var emojis: [LFSEmoji]!
    private var emojiSetions: [String]!
    
    internal var didChoose: (() -> Void)?
    
    init(delegate: LFSEmojiViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        emojis = [LFSEmoji]()
        emojiSetions = [String]()
    }
    
    override func close() {
        delegate?.dismissedView()
        didChoose?()
        super.close()
    }
}

//MARK: Base
extension LFSEmojiViewModel {
    internal func setup() {
        DispatchQueue.main.async { [unowned self] in
            self.generateEmojiSystem()
            self.generateEmojiSelf()
            self.getSection()
            self.delegate?.fetchedEmoji()
        }
    }
    
    fileprivate func generateEmojiSystem() {
        for value in LFSConstants.LFSEmoji.allEmojis {
            let emoji = LFSEmoji(name: "EmojiSystem\(value)", section: LFSConstants.LFSEmoji.emojiSystemSection, value: value)
            
            emojis.append(emoji)
        }
    }
    
    fileprivate func generateEmojiSelf() {
        for i in 1...75 {
            if let image = UIImage(named: "Emo\(i)") {
                let emoji = LFSEmoji(name: "EmojiSelf\(i)", section: LFSConstants.LFSEmoji.emojiSelfSection, value: image)
                
                emojis.append(emoji)
            }
        }
    }
    
    fileprivate func getSection() {
        emojiSetions = LFSEditModel.shared.getEmojiSections(emojis: emojis)
    }
}

//MARK: LFSCollectionViewPresentable
extension LFSEmojiViewModel: LFSCollectionViewPresentable {
    internal func numberOfSections() -> Int {
        return emojiSetions.count
    }
    
    internal func numberOfItems(section: Int) -> Int {
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: emojiSetions[section])
        return _emojis.count
    }
    
    internal func cellForItem(with collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let section = emojiSetions[indexPath.section]
        
        switch section {
        case LFSConstants.LFSEmoji.emojiSystemSection:
            return cellForEmojiSystem(collectionView: collectionView, section: section, indexPath: indexPath)
        case LFSConstants.LFSEmoji.emojiSelfSection:
            return cellForEmojiSelf(collectionView: collectionView, section: section, indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    internal func didSelected(with collectionView: UICollectionView, at indexPath: IndexPath) {
        
    }
}

//MARK: Handle Emoji System Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSystem(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiLabelCollectionViewCell, for: indexPath) as! LFSEmojiLabelCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
        
        cell.emojiLabel.text = emoji.value as? String
        
        return cell
    }
}

//MARK: Handle Emoji Self Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSelf(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiImageSystemCollectionViewCell, for: indexPath) as! LFSEmojiImageSystemCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
      
        cell.emojiSystemImageView.image = emoji.value as? UIImage
        
        return cell
    }
}

//MARK: Send Value by LFSEmojiDelegate
extension LFSEmojiViewModel {
    
}

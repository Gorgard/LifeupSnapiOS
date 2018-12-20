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
    
    init(delegate: LFSEmojiViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        emojis = [LFSEmoji]()
        emojiSetions = [String]()
    }
}

//MARK: Base
extension LFSEmojiViewModel {
    internal func setup() {
        generateEmojiSystem()
        generateEmojiSelf()
    }
    
    fileprivate func generateEmojiSystem() {
        for range in LFSConstants.LFSEmoji.emojiRanges {
            for i in range {
                let value = String(UnicodeScalar(i)!)
                
                let emoji = LFSEmoji(name: "EmojiSystem\(i)", section: LFSConstants.LFSEmoji.emojiSystemSection, value: value)
                
                emojis.append(emoji)
            }
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
        
    }
}

//MARK: LFSCollectionViewPresentable
extension LFSEmojiViewModel: LFSCollectionViewPresentable {
    func numberOfSections() -> Int {
        return emojiSetions.count
    }
    
    func numberOfItems(section: Int) -> Int {
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: emojiSetions[section])
        return _emojis.count
    }
    
    func cellForItem(with collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func didSelected(with collectionView: UICollectionView, at indexPath: IndexPath) {
        
    }
}

//MARK: Handle Emoji System Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSystem(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiCollectionViewCell, for: indexPath) as! LFSEmojiCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
        
        cell.makeLabel(value: emoji.value)
        
        return cell
    }
}

//MARK: Handle Emoji Self Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSelf(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiCollectionViewCell, for: indexPath) as! LFSEmojiCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
        
        cell.makeImage(value: emoji.value)
        
        return cell
    }
}

//MARK: Send Value by LFSEmojiDelegate
extension LFSEmojiViewModel {
    
}

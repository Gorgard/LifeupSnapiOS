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
    
    //private var emojiSync: LFSEmojiSync!
    
    private var emojis: [LFSEmoji]!
    private var emojiSetions: [String]!
    
    private var emoji: LFSEmoji!
    
    private var initialed: Bool = false
    
    internal var receivedEmojiView: ((_ emojiView: EmojiView) -> Void)?
    internal var didChoose: (() -> Void)?
    
    init(delegate: LFSEmojiViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        //emojiSync = LFSEmojiSync()
        
        emojis = [LFSEmoji]()
        emojiSetions = [String]()
    }
    
    deinit {
        removeAll()
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
        taskMain { [unowned self] in
            self.generateEmojiSystem()
            self.generateEmojiSelf()
            self.getSection()
            self.delegate?.fetchedEmoji()
        }
    }
    
    fileprivate func generateEmojiSystem() {
//        emojiSync.getEmojiSystem()
//        emojis = emojiSync.emojiSystems
    }
    
    fileprivate func generateEmojiSelf() {
        for i in 1...75 {
            if let image = UIImage(named: "Emo\(i)")?.resizeWithWidth(width: 50) {
                let emoji = LFSEmoji(name: "EmojiSelf\(i)", section: LFSConstants.LFSEmoji.emojiSelfSection, value: image)

                emojis.append(emoji)
            }
        }
    }
    
    fileprivate func getSection() {
        emojiSetions = LFSEditModel.shared.getEmojiSections()
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
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: emojiSetions[indexPath.section])
        emoji = _emojis[indexPath.row]
        delegate?.choosedEmoji()
    }
}

//MARK: Handle Emoji System Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSystem(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiSystemCollectionViewCell, for: indexPath) as! LFSEmojiSystemCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
        
        cell.emojiImageView.image = emoji.value
        
        return cell
    }
}

//MARK: Handle Emoji Self Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSelf(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LFSConstants.LFSCollectionViewCellID.Edit.lfsEmojiSelfCollectionViewCell, for: indexPath) as! LFSEmojiSelfCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
      
        cell.emojiImageView.image = emoji.value
        
        return cell
    }
}

//MARK: Send Value by LFSEmojiDelegate
extension LFSEmojiViewModel {
    internal func generateEmoji() {
        guard let emoji = emoji else {
            didChoose?()
            return
        }
        
        let image = emoji.value
        let emojiView = EmojiView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        emojiView.addImage(image: image)
        
        receivedEmojiView?(emojiView)
        
        didChoose?()
    }
}

//MARK: UIScrollViewDelegate
extension LFSEmojiViewModel {
    internal func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let maxmumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxmumOffset - currentOffset <= 10.0 {
            loadMore(completion: { [unowned self] in
                self.delegate?.fetchedEmoji()
            })
        }
    }
    
    fileprivate func loadMore(completion: @escaping() -> Void) {
        self.generateEmojiSystem()
        taskMain { [unowned self] in
            completion()
        }
    }
}

//MARK: Remove All
extension LFSEmojiViewModel {
    fileprivate func removeAll() {
        delegate = nil
        emojis = nil
        emojiSetions = nil
        didChoose = nil
        //emojiSync = nil
        receivedEmojiView = nil
    }
}

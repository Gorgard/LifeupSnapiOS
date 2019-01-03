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
    
    private var emojiModel: LFSEmojiModel!
    
    private var emojis: [LFSEmoji] = [LFSEmoji]()
    private var emojiSetions: [String]!
    
    private var emoji: LFSEmoji!
    
    private var initialed: Bool = false
    
    internal var receivedEmojiView: ((_ emojiView: EmojiView) -> Void)?
    internal var didChoose: (() -> Void)?
    
    init(delegate: LFSEmojiViewModelDelegate) {
        super.init()
        self.delegate = delegate
        
        emojiModel = LFSEmojiModel()
  
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
            self.generateEmojiSelf()
            self.generateEmojiSystem()
            self.getSection()
            self.delegate?.fetchedEmoji()
        }
    }
    
    fileprivate func generateEmojiSystem() {
        emojis += emojiModel.loadMoreEmojiSystems()
    }
    
    fileprivate func generateEmojiSelf() {
        emojis = emojiModel.loadMoreEmojiSelfs()
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
    
    internal func willDisplay(with collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: emojiSetions[indexPath.section])
        if indexPath.row == _emojis.count - 1 {
            loadMore(completion: { [weak self] in
                self?.delegate?.fetchedEmoji()
            })
        }
    }
}

//MARK: Handle Emoji System Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSystem(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLfsEmojiSystemCollectionViewCell, for: indexPath) as! LFSEmojiSystemCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
        
        cell.emojiImageView.lfsImageCache(with: emoji.value as? String)
        
        return cell
    }
}

//MARK: Handle Emoji Self Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSelf(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLfsEmojiSelfCollectionViewCell, for: indexPath) as! LFSEmojiSelfCollectionViewCell
        let _emojis = LFSEditModel.shared.filterEmojisInEachSection(emojis: emojis, section: section)
        let emoji = _emojis[indexPath.row]
      
        cell.emojiImageView.image = emoji.value as? UIImage
        
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
        
        if let selfImage = emoji.value as? UIImage {
            let emojiView = EmojiView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            emojiView.addImage(image: selfImage)
            
            receivedEmojiView?(emojiView)
        }
        
        if let systemString = emoji.value as? String {
            if let image = LFSImageCache.shared.image(forKey: systemString) {
                let emojiView = EmojiView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                emojiView.addImage(image: image)
                
                receivedEmojiView?(emojiView)
            }
        }
        
        didChoose?()
    }
}

//MARK: Load more
extension LFSEmojiViewModel {    
    fileprivate func loadMore(completion: @escaping() -> Void) {
        generateEmojiSystem()
        
        taskMainAfter(deadline: .now() + 1, {
            completion()
        })
    }
}

//MARK: Remove All
extension LFSEmojiViewModel {
    fileprivate func removeAll() {
        delegate = nil
        emojis.removeAll()
        emojiSetions = nil
        didChoose = nil
        emojiModel = nil
        receivedEmojiView = nil
    }
}

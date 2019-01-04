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
    
    private var emojiSystems: [LFSEmoji] = [LFSEmoji]()
    private var emojiSelfs: [LFSEmoji] = [LFSEmoji]()
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
        emojiSystems += emojiModel.loadMoreEmojiSystems()
    }
    
    fileprivate func generateEmojiSelf() {
        emojiSelfs = emojiModel.loadMoreEmojiSelfs()
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
        let section = emojiSetions[section]
        
        switch section {
        case LFSConstants.LFSEmoji.kEmojiSystemSection:
            return emojiSystems.count
        case LFSConstants.LFSEmoji.kEmojiSelfSection:
            return emojiSelfs.count
        default:
            return 0
        }
    }
    
    internal func cellForItem(with collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let section = emojiSetions[indexPath.section]
        
        switch section {
        case LFSConstants.LFSEmoji.kEmojiSystemSection:
            return cellForEmojiSystem(collectionView: collectionView, section: section, indexPath: indexPath)
        case LFSConstants.LFSEmoji.kEmojiSelfSection:
            return cellForEmojiSelf(collectionView: collectionView, section: section, indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    internal func didSelected(with collectionView: UICollectionView, at indexPath: IndexPath) {
        let section = emojiSetions[indexPath.section]

        switch section {
        case LFSConstants.LFSEmoji.kEmojiSystemSection:
            emoji = emojiSystems[indexPath.row]
        case LFSConstants.LFSEmoji.kEmojiSelfSection:
            emoji = emojiSelfs[indexPath.row]
        default:
            break
        }
        
        delegate?.choosedEmoji()
    }
    
    internal func willDisplay(with collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        let section = emojiSetions[indexPath.section]
        var emojis: [LFSEmoji] = [LFSEmoji]()
        
        switch section {
        case LFSConstants.LFSEmoji.kEmojiSystemSection:
            emojis = emojiSystems
        case LFSConstants.LFSEmoji.kEmojiSelfSection:
            emojis = emojiSelfs
        default:
            break
        }
        
        if indexPath.row == emojis.count - 1 {
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
        let emoji = emojiSystems[indexPath.row]
        
        cell.emojiImageView.lfsImageCache(with: emoji.value as? String)
        
        return cell
    }
}

//MARK: Handle Emoji Self Cell
extension LFSEmojiViewModel {
    fileprivate func cellForEmojiSelf(collectionView: UICollectionView, section: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLfsEmojiSelfCollectionViewCell, for: indexPath) as! LFSEmojiSelfCollectionViewCell
        let emoji = emojiSelfs[indexPath.row]
      
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
        emojiSystems.removeAll()
        emojiSelfs.removeAll()
        emojiSetions = nil
        didChoose = nil
        emojiModel = nil
        receivedEmojiView = nil
    }
}

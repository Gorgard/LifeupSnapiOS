//
//  LFSCollectionViewPresentable.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

@objc internal protocol LFSCollectionViewPresentable: NSObjectProtocol {
    func numberOfSections() -> Int
    func numberOfItems(section: Int) -> Int
    func cellForItem(with collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    
    @objc optional func didSelected(with collectionView: UICollectionView, at indexPath: IndexPath)
}

//
//  LFSSnapDelegate.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

@objc public protocol LFSSnapDelegate: class {
    @objc optional func snapVideo(whenSaved receiveURL: URL)
    @objc optional func snapVideo(whenNextAfterEdited receiveVideo: Data)
    @objc optional func snapPhoto(whenSaved receivePhoto: UIImage)
    @objc optional func snapPhoto(whenNextAfterEdited receivePhoto: UIImage)
}

//
//  LFSEditModel.swift
//  LifeupSnap
//
//  Created by lifeup on 14/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class LFSEditModel: LFSBaseModel {
    internal static let shared: LFSEditModel = LFSEditModel()
    
    func sizeOfString(string: String, constrainedToWidth width: Double) -> CGSize {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .medium)]
        let attributeString = NSAttributedString(string: string, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributeString)
        
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
    }
}

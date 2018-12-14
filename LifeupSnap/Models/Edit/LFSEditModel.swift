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
    
    internal func attributeText(text: String?, currentPalleteColor: LFSColor?, isBorder: Bool) -> NSMutableAttributedString? {
        guard let text = text, let color = currentPalleteColor?.color else {
            return nil
        }
        
        let attributeString = NSMutableAttributedString(string: text)
        let startIndex = text.startIndex.encodedOffset
        
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        
        if isBorder {
            backgroundColor = color
            foregroundColor = .white
        }
        else {
            backgroundColor = .clear
            foregroundColor = color
        }
        
        let range = NSRange(location: startIndex, length: text.count)
        let font = UIFont.systemFont(ofSize: 30, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributeString.addAttribute(.backgroundColor, value: backgroundColor, range: range)
        attributeString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        
        return attributeString
    }
}

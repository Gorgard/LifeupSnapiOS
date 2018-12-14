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
        guard var text = text, !text.isEmpty, let color = currentPalleteColor?.color else {
            return nil
        }
        
        text = text.replacingOccurrences(of: "\n", with: "")
        text = text.inserting(separator: "\n", every: 25)
        
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
        
        let range = NSRange(location: startIndex, length: text.unicodeScalars.count)
        let font = UIFont.systemFont(ofSize: 30, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributeString.addAttribute(.backgroundColor, value: backgroundColor, range: range)
        attributeString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        
        return attributeString
    }
    
    internal func calculateSizeOfTextView(attributeString: NSMutableAttributedString) -> CGSize {
        let text = attributeString.string
        let attributes = attributeString.attributes(at: 0, longestEffectiveRange: nil, in: NSRange.init(location: 0, length: attributeString.string.count))
        let size = (text as NSString).size(withAttributes: attributes)
        
        let width = UIScreen.main.bounds.size.width - 100
        let height = (size.height + width) * 1.5
        
        let realSize = CGSize(width: width, height: height)
        
        return realSize
    }
}

//
//  AttributedStringHelper.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

func +(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: left)
    result.append(right)
    
    return result
}

func +(left: NSAttributedString, right: String) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: left)
    result.append(NSAttributedString(string: right))
    
    return result
}

fileprivate func paragraphStyleWith(lineSpacing: CGFloat) -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byTruncatingTail
    paragraphStyle.lineSpacing = lineSpacing
    
    return paragraphStyle
}

extension String {
    func attributed() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    func attributed(withColor color: UIColor) -> NSAttributedString {
        return attributed(withAttributes: [NSForegroundColorAttributeName: color])
    }
    
    func attributed(withSpacing spacing: CGFloat) -> NSAttributedString {
        return attributed(withAttributes: [NSKernAttributeName: spacing])
    }
    
    func attributed(withFont font: UIFont) -> NSAttributedString {
        return attributed(withAttributes: [NSFontAttributeName: font])
    }
    
    func attributed(withLineSpacing lineSpacing: CGFloat) -> NSAttributedString {
        return attributed(withAttributes: [NSParagraphStyleAttributeName: paragraphStyleWith(lineSpacing: lineSpacing)])
    }
    
    func attributed(withAttributes attributes: [String : Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}

extension NSAttributedString {
    func with(color: UIColor) -> NSAttributedString {
        return with(attributes: [NSForegroundColorAttributeName: color])
    }
    
    func with(spacing: CGFloat) -> NSAttributedString {
        return with(attributes: [NSKernAttributeName: spacing])
    }
    
    func with(font: UIFont) -> NSAttributedString {
        return with(attributes: [NSFontAttributeName: font])
    }
    
    func with(lineSpacing: CGFloat) -> NSAttributedString {
        return with(attributes: [NSParagraphStyleAttributeName: paragraphStyleWith(lineSpacing: lineSpacing)])
    }
    
    func with(attributes: [String : Any]) -> NSAttributedString {
        let fullRange = NSRange(location: 0, length: string.characters.count)
        let newString = NSMutableAttributedString(attributedString: self)
        newString.addAttributes(attributes, range: fullRange)
        
        return newString
    }
}

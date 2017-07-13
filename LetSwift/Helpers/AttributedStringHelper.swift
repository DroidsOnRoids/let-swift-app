//
//  AttributedStringHelper.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

fileprivate func paragraphStyleWith(lineHeight: CGFloat) -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    
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
    
    func attributed(withLineHeight lineHeight: CGFloat) -> NSAttributedString {
        return attributed(withAttributes: [NSParagraphStyleAttributeName: paragraphStyleWith(lineHeight: lineHeight)])
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
    
    func with(lineHeight: CGFloat) -> NSAttributedString {
        return with(attributes: [NSParagraphStyleAttributeName: paragraphStyleWith(lineHeight: lineHeight)])
    }
    
    func with(attributes: [String : Any]) -> NSAttributedString {
        let fullRange = NSRange(location: 0, length: string.characters.count)
        let newString = NSMutableAttributedString(attributedString: self)
        newString.addAttributes(attributes, range: fullRange)
        
        return newString
    }
}

//
//  AttributedStringHelper.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

func +(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

extension String {
    func attributed() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    func attributed(withColor color: UIColor) -> NSAttributedString {
        let colorAttribute = [ NSForegroundColorAttributeName: color ]
        return NSAttributedString(string: self, attributes: colorAttribute)
    }
    
    func attributed(withSping scpacing: CGFloat) -> NSAttributedString {
        let spacingAttribute = [ NSKernAttributeName: scpacing ]
        return NSAttributedString(string: self, attributes: spacingAttribute)
    }
}

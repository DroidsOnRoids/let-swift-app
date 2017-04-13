//
//  MultiSizeConstraint.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class MultiSizeConstraint: NSLayoutConstraint {
    
    @IBInspectable
    var inch3¨5: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 480 {
                constant = inch3¨5
            }
        }
    }
    
    @IBInspectable
    var inch4¨0: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 568 {
                constant = inch4¨0
            }
        }
    }
    
    @IBInspectable
    var inch4¨7: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 667 {
                constant = inch4¨7
            }
        }
    }
    
    @IBInspectable
    var inch5¨5: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 736 {
                constant = inch5¨5
            }
        }
    }
}

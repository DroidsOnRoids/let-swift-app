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
    var inch3¨5: CGFloat = 0.0 {
        didSet {
            constant = ScreenDiagonalSize.inch3¨5(inch3¨5).value
        }
    }
    
    @IBInspectable
    var inch4¨0: CGFloat = 0.0 {
        didSet {
            constant = ScreenDiagonalSize.inch3¨5(inch3¨5).value
        }
    }
    
    @IBInspectable
    var inch4¨7: CGFloat = 0.0 {
        didSet {
            constant = ScreenDiagonalSize.inch3¨5(inch3¨5).value
        }
    }
    
    @IBInspectable
    var inch5¨5: CGFloat = 0.0 {
        didSet {
            constant = ScreenDiagonalSize.inch3¨5(inch3¨5).value
        }
    }
    
}

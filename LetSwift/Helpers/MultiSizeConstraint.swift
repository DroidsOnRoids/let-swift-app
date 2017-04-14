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
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch3¨5.rawValue {
                constant = inch3¨5
            }
        }
    }
    
    @IBInspectable
    var inch4¨0: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch4¨0.rawValue {
                constant = inch4¨0
            }
        }
    }
    
    @IBInspectable
    var inch4¨7: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch4¨7.rawValue {
                constant = inch4¨7
            }
        }
    }
    
    @IBInspectable
    var inch5¨5: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch5¨5.rawValue {
                constant = inch5¨5
            }
        }
    }
    
}

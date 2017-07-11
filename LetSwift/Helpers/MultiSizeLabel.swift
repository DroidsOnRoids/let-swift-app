//
//  MultiSizeLabel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class MultiSizeLabel: UILabel {
    
    @IBInspectable
    var inch3¨5: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch3¨5 {
                font = font.withSize(inch3¨5)
            }
        }
    }
    
    @IBInspectable
    var inch4¨0: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch4¨0 {
                font = font.withSize(inch4¨0)
            }
        }
    }
    
    @IBInspectable
    var inch4¨7: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch4¨7 {
                font = font.withSize(inch4¨7)
            }
        }
    }
    
    @IBInspectable
    var inch5¨5: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch5¨5 {
                font = font.withSize(inch5¨5)
            }
        }
    }
}

//
//  MultiSizeConstraint.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
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

class MultiSizeConstraint: NSLayoutConstraint {
    
    @IBInspectable
    var inch3¨5: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch3¨5 {
                constant = inch3¨5
            }
        }
    }
    
    @IBInspectable
    var inch4¨0: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch4¨0 {
                constant = inch4¨0
            }
        }
    }
    
    @IBInspectable
    var inch4¨7: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch4¨7 {
                constant = inch4¨7
            }
        }
    }
    
    @IBInspectable
    var inch5¨5: CGFloat = 0.0 {
        didSet {
            if DeviceScreenHeight.deviceHeight == DeviceScreenHeight.inch5¨5 {
                constant = inch5¨5
            }
        }
    }
    
}

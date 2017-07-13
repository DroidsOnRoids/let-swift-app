//
//  TappableView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 15.05.2017.
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

final class TappableView: UIView {
    
    @IBInspectable var selectionColor: UIColor? = .lightBlueGrey
    
    private var originalBackground: UIColor!
    private var isTouchDown = false
    
    private weak var target: AnyObject?
    private var action: Selector?
    
    func addTarget(_ target: Any?, action: Selector) {
        self.target = target as AnyObject
        self.action = action
    }
    
    @discardableResult private func releaseTouchIfNeeded() -> Bool {
        if isTouchDown {
            isTouchDown = false
            backgroundColor = originalBackground
            
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchDown = true
        originalBackground = backgroundColor
        
        if let selectionColor = selectionColor {
            backgroundColor = selectionColor
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if releaseTouchIfNeeded() {
            _ = target?.perform(action)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        releaseTouchIfNeeded()
    }
}

//
//  AttendButtonsRowTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
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

final class AttendButtonsRowTableViewCell: UITableViewCell {

    @IBOutlet private weak var attendButton: AppShadowButton!
    @IBOutlet private weak var remindButton: AppShadowButton!
    @IBOutlet private weak var currentEventConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pastEventConstraint: NSLayoutConstraint!
    
    private enum Constants {
        static let lowPriorityConstraint = UILayoutPriority(250.0)
        static let highPriorityContraint = UILayoutPriority(999.0)
    }
    
    var isLeftButtonActive = true {
        didSet {
            attendButton.backgroundColor = isLeftButtonActive ? EventBranding.current.color : .paleGrey
            attendButton.isEnabled = isLeftButtonActive
        }
    }
    
    var isRightButtonVisible = true {
        didSet {
            guard isRightButtonVisible != oldValue else { return }
            
            if isRightButtonVisible {
                currentEventConstraint.priority = Constants.highPriorityContraint
                pastEventConstraint.priority = Constants.lowPriorityConstraint
            } else {
                currentEventConstraint.priority = Constants.lowPriorityConstraint
                pastEventConstraint.priority = Constants.highPriorityContraint
            }
            
            UIView.animate(withDuration: 0.2) {
                self.remindButton.isHidden = !self.isRightButtonVisible
                self.layoutIfNeeded()
            }
        }
    }
    
    var leftButtonTitle: String {
        get {
            return attendButton.currentTitle ?? ""
        }
        set {
            attendButton.setTitle(newValue.uppercased(), for: [])
        }
    }
    
    var rightButtonTitle: String {
        get {
            return remindButton.currentTitle ?? ""
        }
        set {
            remindButton.setTitle(newValue.uppercased(), for: [])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remindButton.layer.borderColor = EventBranding.current.color.cgColor
    }
    
    func addLeftTapTarget(target: Any?, action: Selector) {
        attendButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addRightTapTarget(target: Any?, action: Selector) {
        remindButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

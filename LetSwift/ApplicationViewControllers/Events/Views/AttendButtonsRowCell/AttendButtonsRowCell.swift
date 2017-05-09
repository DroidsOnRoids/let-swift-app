//
//  AttendButtonsRowCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AttendButtonsRowCell: UITableViewCell {

    @IBOutlet weak var attendButton: AppShadowButton!
    @IBOutlet weak var remindButton: AppShadowButton!
    @IBOutlet private weak var currentEventConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pastEventConstraint: NSLayoutConstraint!
    
    private enum Constants {
        static let lowPriorityConstraint: Float = 250.0
        static let highPriorityContraint: Float = 999.0
    }
    
    var attendButtonActive = true {
        didSet {
            attendButton.backgroundColor = attendButtonActive ? .swiftOrange : .paleGrey
            attendButton.isEnabled = attendButtonActive
        }
    }

    var isRemindButtonVisible = true {
        didSet {
            if isRemindButtonVisible {
                currentEventConstraint.priority = Constants.highPriorityContraint
                pastEventConstraint.priority = Constants.lowPriorityConstraint
            } else {
                currentEventConstraint.priority = Constants.lowPriorityConstraint
                pastEventConstraint.priority = Constants.highPriorityContraint
            }
            
            UIView.animate(withDuration: 0.2) {
                self.remindButton.isHidden = !self.isRemindButtonVisible
                self.attendButton.superview?.layoutIfNeeded()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remindButton.layer.borderColor = UIColor.swiftOrange.cgColor
    }
}

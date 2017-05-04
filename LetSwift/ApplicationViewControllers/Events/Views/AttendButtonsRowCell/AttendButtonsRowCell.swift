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
    
    var attendButtonActive = true {
        didSet {
            attendButton.backgroundColor = attendButtonActive ? .swiftOrange : .paleGrey
            attendButton.isEnabled = attendButtonActive
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remindButton.layer.borderColor = UIColor.swiftOrange.cgColor
    }
}

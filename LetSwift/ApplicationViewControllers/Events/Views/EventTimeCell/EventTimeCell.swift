//
//  EventTimeCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventTimeCell: UITableViewCell {
    
    @IBOutlet private weak var separatorConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
    }
}

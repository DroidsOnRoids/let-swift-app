//
//  AppTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateSelectionColor()
    }
    
    @IBInspectable
    var selectionColor: UIColor = .lightBlueGrey {
        didSet {
            updateSelectionColor()
        }
    }
    
    private func updateSelectionColor() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = selectionColor
        selectedBackgroundView = backgroundView
    }
}

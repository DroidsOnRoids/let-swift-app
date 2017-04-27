//
//  EventLocationCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventLocationCell: UITableViewCell {
    
    @IBOutlet private weak var locationLabel: UILabel!
    
    var placeName: String = "" {
        didSet {
            refreshLocationLabel()
        }
    }
    
    var placeLocation: String = "" {
        didSet {
            refreshLocationLabel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        refreshLocationLabel()
    }
    
    private func refreshLocationLabel() {
        locationLabel.attributedText = placeName.uppercased()
            .attributed(withFont: UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightSemibold))
            .with(color: .black) + " — " + placeLocation.attributed()
    }
}

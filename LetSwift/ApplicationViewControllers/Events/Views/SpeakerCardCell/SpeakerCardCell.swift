//
//  SpeakerCardListCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 11.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerCardCell: UITableViewCell {
    
    @IBOutlet weak var card: SpeakerCardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: bounds.width)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        card.highlightView(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        card.highlightView(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        card.highlightView(false)
    }
}

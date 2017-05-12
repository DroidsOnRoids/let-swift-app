//
//  SpeakerCardListCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 11.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerCardCell: UITableViewCell {
    
    @IBOutlet private weak var internalView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: bounds.width)
        
        internalView.layer.shadowColor = UIColor.black.cgColor
        internalView.layer.shadowOpacity = 0.1
        internalView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        internalView.layer.shadowRadius = 10.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        internalView.highlightView(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        internalView.highlightView(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        internalView.highlightView(false)
    }
}

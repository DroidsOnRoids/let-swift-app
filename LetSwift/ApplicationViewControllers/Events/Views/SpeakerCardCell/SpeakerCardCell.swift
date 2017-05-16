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
    
    private var speakerTapListener: (() -> Void)?
    private var readMoreTapListener: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: bounds.width)
        
        card.addSpeakerTapTarget(target: self, action: #selector(speakerDidTap))
        card.addReadMoreTapTarget(target: self, action: #selector(readMoreDidTap))
    }
    
    func addTapListeners(speaker: @escaping () -> Void, readMore: @escaping () -> Void) {
        speakerTapListener = speaker
        readMoreTapListener = readMore
    }
    
    @objc private func speakerDidTap() {
        speakerTapListener?()
    }
    
    @objc private func readMoreDidTap() {
        readMoreTapListener?()
    }
}

//
//  WebsiteView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class WebsiteView: DesignableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var website: SpeakerWebsite?
    
    convenience init(website: SpeakerWebsite, showLabel: Bool) {
        self.init()
        self.website = website
        
        iconImageView.image = website.image
        titleLabel.text = website.title
        titleLabel.isHidden = !showLabel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView(false)
        let shouldOpen = touches.reduce(false) { result, touch in
            return result || frame.contains(touch.location(in: self))
        }
        
        if shouldOpen {
            website?.open()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView(false)
    }
}

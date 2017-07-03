//
//  SpeakerWebsitesTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerWebsitesTableViewCell: UITableViewCell, SpeakerLoadable {
    
    static let cellIdentifier = String(describing: SpeakerWebsitesTableViewCell.self)
    
    @IBOutlet private weak var stackView: UIStackView!
    
    func load(with speaker: Speaker) {
        let showLabel = speaker.websites.count <= 2
        
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        speaker.websites.forEach { website in
            let websiteView = WebsiteView(website: website, showLabel: showLabel)
            stackView.addArrangedSubview(websiteView)
        }
    }
}

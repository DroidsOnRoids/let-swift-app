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
        speaker.websites.forEach { website in
            stackView.addArrangedSubview(WebsiteView(website: website, showLabel: false))
        }
    }
}

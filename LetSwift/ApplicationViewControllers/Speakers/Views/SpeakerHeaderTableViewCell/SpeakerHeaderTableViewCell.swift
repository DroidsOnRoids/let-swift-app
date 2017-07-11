//
//  SpeakerHeaderTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerHeaderTableViewCell: UITableViewCell, SpeakerLoadable {
    
    private enum Constants {
        static let shadowInset: CGFloat = 10.0
        static let shadowOffset: CGFloat = 30.0
        static let shadowRadius: CGFloat = 15.0
    }
    
    static let cellIdentifier = String(describing: SpeakerHeaderTableViewCell.self)

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: AppLabel!
    @IBOutlet private weak var jobLabel: AppLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func load(with speaker: Speaker) {
        avatarImageView.sd_setImage(with: speaker.avatar?.thumb, placeholderImage: #imageLiteral(resourceName: "PhotoMock"))
        nameLabel.text = speaker.name
        jobLabel.text = speaker.job
            
        if !speaker.websites.isEmpty {
            removeSeparators()
        }
    }
    
    private func setup() {
        setupAvatarShadow()
    }
    
    private func setupAvatarShadow() {
        guard let shadowView = avatarImageView.superview else { return }
        
        let shadowRect = shadowView.bounds.insetBy(dx: Constants.shadowInset, dy: Constants.shadowOffset)
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        shadowView.addShadow(offset: CGSize(width: 0.0, height: Constants.shadowOffset), radius: Constants.shadowRadius)
    }
}

//
//  SpeakerHeaderTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerHeaderTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let shadowInset: CGFloat = 10.0
        static let shadowOffset: CGFloat = 30.0
        static let shadowRadius: CGFloat = 15.0
    }
    
    static let cellIdentifier = String(describing: SpeakerHeaderTableViewCell.self)

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    
    var avatarURL: URL? {
        didSet {
            avatarImageView.sd_setImage(with: avatarURL, placeholderImage: #imageLiteral(resourceName: "PhotoMock"))
        }
    }
    
    var speakerName: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var speakerJob: String? {
        get {
            return jobLabel.text
        }
        set {
            jobLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
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

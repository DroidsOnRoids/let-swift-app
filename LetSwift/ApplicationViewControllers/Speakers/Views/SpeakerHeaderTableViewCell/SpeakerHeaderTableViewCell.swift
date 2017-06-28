//
//  SpeakerHeaderTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerHeaderTableViewCell: UITableViewCell {
    
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
        
        let shadowRect = shadowView.bounds.insetBy(dx: 10.0, dy: 30.0)
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        shadowView.addShadow(offset: CGSize(width: 0.0, height: 30.0), radius: 15.0)
    }
}

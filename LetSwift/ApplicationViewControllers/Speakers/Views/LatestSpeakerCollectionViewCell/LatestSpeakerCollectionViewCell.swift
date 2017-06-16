//
//  LatestSpeakerCollectionViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class LatestSpeakerCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: LatestSpeakerCollectionViewCell.self)

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var surnameLabel: UILabel!
    @IBOutlet private weak var indicatorImageView: UIImageView!

    override var isHighlighted: Bool {
        didSet {
            highlightView(isHighlighted)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func load(with speaker: Speaker) {
        if let name = speaker.name.components(separatedBy: " ").first {
            nameLabel.text = name
        }

        if let surname = speaker.name.components(separatedBy: " ").last {
            surnameLabel.text = surname
        }

        imageView.sd_setImage(with: speaker.avatar?.thumb, placeholderImage: #imageLiteral(resourceName: "PhotoMock"))
    }

    private func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5.0

        indicatorImageView.image = indicatorImageView.image?.withRenderingMode(.alwaysTemplate)
        indicatorImageView.tintColor = .white

        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds

        let startColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1)
        let endColor = UIColor.black

        gradient.locations = [0.4, 1.0]
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        imageView.layer.insertSublayer(gradient, at: 0)
    }
}

//
//  LatestSpeakerCollectionViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LatestSpeakerCollectionViewCell: UICollectionViewCell, SpeakerLoadable {

    static let cellIdentifier = String(describing: LatestSpeakerCollectionViewCell.self)

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: AppLabel!
    @IBOutlet private weak var surnameLabel: AppLabel!
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

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let _ = imageView.image else { return }
        imageView.addGradientShadow(with: [0.4, 1.0])
    }

    func load(with speaker: Speaker) {
        if let name = speaker.name.components(separatedBy: " ").first {
            nameLabel.text = name
        }

        if let surname = speaker.name.components(separatedBy: " ").last {
            surnameLabel.text = surname
        }

        imageView.removeAllLayers()
        imageView.sd_setImage(with: speaker.avatar?.thumb) { [weak self] image, _, _, _ in
            self?.imageView.addGradientShadow(with: [0.4, 1.0])
            guard image == nil else { return }

            self?.imageView.image = #imageLiteral(resourceName: "PhotoMock")
        }
    }

    private func setup() {
        addShadow()

        indicatorImageView.image = indicatorImageView.image?.withRenderingMode(.alwaysTemplate)
        indicatorImageView.tintColor = .white
    }
}

//
//  LatestSpeakerCollectionViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

final class LatestSpeakerCollectionViewCell: UICollectionViewCell, SpeakerLoadable {

    static let cellIdentifier = String(describing: LatestSpeakerCollectionViewCell.self)

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var gradientView: GradientView!
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

    func load(with speaker: Speaker) {
        if let name = speaker.name.components(separatedBy: " ").first {
            nameLabel.text = name
        }

        if let surname = speaker.name.components(separatedBy: " ").last {
            surnameLabel.text = surname
        }
        
        imageView.sd_setImage(with: speaker.avatar?.thumb) { [weak self] image, _, _, _ in
            let isNoImage = image == nil
            
            self?.gradientView.isHidden = isNoImage
            if isNoImage {
                self?.imageView.image = #imageLiteral(resourceName: "LatestSpeakerPlaceholder")
            }
        }
    }

    private func setup() {
        addShadow()

        indicatorImageView.image = indicatorImageView.image?.withRenderingMode(.alwaysTemplate)
        indicatorImageView.tintColor = .white
    }
}

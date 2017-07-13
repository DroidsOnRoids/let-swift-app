//
//  PreviousEventCollectionViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.04.2017.
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
import SDWebImage

final class PreviousEventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: AppLabel!
    @IBOutlet private weak var dateLabel: AppLabel!
    
    static let cellIdentifier = String(describing: PreviousEventCollectionViewCell.self)
    
    override var isHighlighted: Bool {
        didSet {
            highlightView(isHighlighted)
        }
    }
    
    var imageURL: URL? {
        didSet {
            imageView.sd_setImage(with: imageURL) { [weak self] image, _, _, _ in
                guard image == nil else { return }

                self?.imageView.image = #imageLiteral(resourceName: "PhotoMock")
            }
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var date: String? {
        get {
            return dateLabel.text
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        addShadow(opacity: 0.1, offset: CGSize(width: 0.0, height: 5.0), radius: 10.0)
    }
}

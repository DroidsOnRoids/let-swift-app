//
//  SinglePhotoCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 06.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import SDWebImage

final class SinglePhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    static let cellIdentifier = String(describing: SinglePhotoCell.self)
    
    override var isHighlighted: Bool {
        didSet {
            highlightView(isHighlighted)
        }
    }

    var imageURL: URL? {
        didSet {
            imageView.sd_setImage(with: imageURL)
        }
    }
}

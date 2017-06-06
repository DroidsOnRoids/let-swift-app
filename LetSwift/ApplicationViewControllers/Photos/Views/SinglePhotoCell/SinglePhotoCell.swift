//
//  SinglePhotoCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 06.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class SinglePhotoCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: SinglePhotoCell.self)
    
    override var isHighlighted: Bool {
        didSet {
            highlightView(isHighlighted)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

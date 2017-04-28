//
//  PreviousEventCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PreviousEventCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: PreviousEventCell.self)
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.05) {
                self.transform = self.isHighlighted ? CGAffineTransform(translationX: 0.0, y: 2.0) : .identity
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius = 10.0
    }
}

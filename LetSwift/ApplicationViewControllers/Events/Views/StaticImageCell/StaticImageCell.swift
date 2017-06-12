//
//  StaticImageCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class StaticImageCell: UITableViewCell {
    
    @IBOutlet private weak var reflectiveImageView: ReflectionShadowView!
    
    var imageURL: URL? {
        get {
            return reflectiveImageView.imageURL
        }
        set {
            reflectiveImageView.imageURL = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: bounds.width * 2.0)
        reflectiveImageView.addParallax()
    }
}

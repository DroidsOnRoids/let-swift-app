//
//  PreviousEventCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import SDWebImage

final class PreviousEventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
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

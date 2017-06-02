//
//  LoadingCollectionViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 01.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var spinnerView: SpinnerView!

    static let cellIdentifier = String(describing: LoadingCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func animateSpinner() {
        spinnerView.animationActive = true
    }

    private func setup() {
        spinnerView.backgroundColor = .clear
        spinnerView.image = #imageLiteral(resourceName: "WhiteSpinner")
    }
}

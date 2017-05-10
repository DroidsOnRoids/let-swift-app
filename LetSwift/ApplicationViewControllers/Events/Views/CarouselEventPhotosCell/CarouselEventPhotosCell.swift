//
//  CarouselEventPhotosCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 09.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class CarouselEventPhotosCell: UITableViewCell {

    var viewModel: CarouselEventPhotosCellViewModel! {
        didSet {
            reactiveSetup()
        }
    }

    private func reactiveSetup() {
        print("done")
    }
}

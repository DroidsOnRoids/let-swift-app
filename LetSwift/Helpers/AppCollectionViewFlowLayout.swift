//
//  AppCollectionViewFlowLayout.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppCollectionViewFlowLayout: UICollectionViewFlowLayout {

    convenience init(with height: CGFloat) {
        self.init()

        itemSize = CGSize(width: UIScreen.main.bounds.width * 0.4, height: height)
        minimumLineSpacing = 8.0
        minimumInteritemSpacing = 8.0
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
}

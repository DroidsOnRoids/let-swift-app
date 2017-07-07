//
//  AppCollectionView.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 07.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppCollectionView: UICollectionView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }
}
